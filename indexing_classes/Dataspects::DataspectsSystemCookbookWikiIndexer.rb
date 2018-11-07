module Dataspects

  class SemanticMediaWikiPage

    def aEntities
      # Process resource data
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//div[@id='siteSub']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//div[@id='contentSub']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//div[@id='jump-to-nav']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//h1[@id='firstHeading']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//span[@id='Content']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//title")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//div[@class='printfooter']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//div[@id='footer']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//div[@id='mw-navigation']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//div[@id='catlinks']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//table[@class='wikitextpostertable']")
      # @oFullHTMLSource.remove_section_from_HasEntityHTMLContent!("//div[@class='HasEntityBlurb']")
      # Declare entity is entire resource
      oEntity = Subject.new(self)
      oEntity.aRemoveThesePredicatesFrom_aHasEntityAnnotations += [
        'HasEntityType',
        'HasEntityTitle',
        'HasEntityTypeAndEntityTitle'
      ]
      # # Customize entity annotations and "override" resource defaults
      # oEntity.set_annotation(oEntity.sHasEntityName, 'HasEntityType',
      #   [{AnnotationObjectValue: sRandomValueForSMWPROPERTYNAME('HasSubjectType')
      #   }]
      # )
      # oEntity.set_annotation(oEntity.sHasEntityName, 'HasEntityTitle',
      #   [{
      #     AnnotationObjectValue: sRandomValueForSMWPROPERTYNAME('HasTitle')
      #   }]
      # )
      # oEntity.set_annotation(oEntity.sHasEntityName, 'HasEntityTypeAndEntityTitle',
      #   [{
      #     AnnotationObjectValue: "#{oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityType')} \"#{oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityTitle')}\""
      #   }]
      # )
      oEntity.add_sPREDICATE_with_sVALUE_to_sSUBJECT_if_rREGEX_in_sSTRING(
        'ContainsMermaidGraph', 'Yes', oEntity.sHasEntityName, /<mermaid2/, @oWikitext.sRawContent
      )
      oEntity.add_sPREDICATE_with_sVALUE_to_sSUBJECT_if_rREGEX_in_sSTRING(
        'ContainsSyntaxHighlighting', 'Yes', oEntity.sHasEntityName, /<syntaxhighlight *lang=/, @oWikitext.sRawContent
      )
      return [ oEntity ]
    end

    def sHasEntityType
      sRandomValueForSMWPROPERTYNAME('HasSubjectType')
    end

    def sHasEntityTypeAndEntityTitle
      sRandomValueForSMWPROPERTYNAME('HasEntityTypeAndEntityTitle')
    end

    def sHasResourceURL
      "http://10.100.0.123:20201/w/index.php/#{sHasResourceName}"
    end

    def sHasEntityBlurb
      sRandomValueForSMWPROPERTYNAME('HasEntityBlurb')
    end

  end

  class DataspectsSystemCookbookWikiIndexer < Indexer

    def initialize
      # [[ThisMethodLogsTo::RailsContainer]]
      @sTIKAServerLabel = 'dataspectsSystemTIKAServer'
      @sProfilesURL = '/usr/src/VOLUMEDIN/myDataspectsSystemCONFIG/system_access_profiles.yml'
      @sElasticsearchClusterName = "dataspectsSystemESCluster"
      @sResourceSiloName = "dataspectsSystemCookbookWiki"
      @sIndexName = "smwckindex-0"
      super
      @oSMW = SemanticMediaWiki.new(@oProfiles, @sResourceSiloName, @hOptions)
    end

    def ajsonResourceURIs
      # [[]]
      ajsonResourceURIs = []
      oSMWPages = Dataspects::Facet.new(@hOptions)
      oSMWPages.from_oSEMANTICMEDIAWIKI(@oSMW) # TODO consider making implicit
      #oSMWPages.from_mASK_QUERIES("[[Community:Component0391914916]]") do |sSMWPageName|
      oSMWPages.from_mCATEGORIES("Entity") do |sSMWPageName|
        ajsonResourceURIs << {
          sSMWPageName: sSMWPageName
        }.to_json
      end
      return ajsonResourceURIs
    end

    def store_RESOURCENAME jsonResourceURI
      oSMWPage = Dataspects::SemanticMediaWikiPage.new(@oSMW, jsonResourceURI)
      oSMWPage.aEntities.each do |oEntity|
        begin
          sJobContext = oEntity.oResource.sHasResourceURL
          hEntityDoc = dskmfStandardDocumentor(oEntity)
          #ap hEntityDoc
        rescue JSON::GeneratorError
          Dataspects.errorMessage("JSON::GeneratorError for #{sJobContext}")
        end
        Dataspects.logMessage("STORING: #{sJobContext}...")
        @oESC.store_jsonDOC_in_sINDEX(hEntityDoc.to_json, @sIndexName)
      end
    end

    def dskmfStandardDocumentor oEntity
      hEntityDoc = {
        # Resource silo level
        OriginatedFromResourceSiloID: oEntity.get_sObjectValue_for_sPREDICATENAME('OriginatedFromResourceSiloID'),
        OriginatedFromResourceSiloLabel: oEntity.get_sObjectValue_for_sPREDICATENAME('OriginatedFromResourceSiloLabel'),
        OriginatedFromResourceSiloType: oEntity.get_sObjectValue_for_sPREDICATENAME('OriginatedFromResourceSiloType'),
        # Resource level
        HasResourceName: oEntity.get_sObjectValue_for_sPREDICATENAME('HasResourceName'),
        HasResourceURL: oEntity.get_sObjectValue_for_sPREDICATENAME('HasResourceURL'),
        HasResourceType: oEntity.get_sObjectValue_for_sPREDICATENAME('HasResourceType'),
        # Entity/subject level
        HasEntityClass: oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityClass'),
        HasEntityName: oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityName'),
        HasEntityType: oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityType'),
        HasEntityURL: oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityURL'),
        HasEntityTitle: oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityTitle'),
        HasEntityBlurb: oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityBlurb'),
        HasEntityContent: oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityContent'),
        HasEntityTypeAndEntityTitle: oEntity.get_sObjectValue_for_sPREDICATENAME('HasEntityTypeAndEntityTitle'),
        HasEntityKeywords: oEntity.get_aObjectValues_for_sPREDICATENAME('HasEntityKeyword'),
        HasEntityAnnotations: oEntity.get_aHasEntityAnnotations # This allows skipping predicates!
      }
    end

  end
end
