oDataspectsOntology = Dataspects::OntologyRepository.new(@oProfiles, @hOptions)
oSMW = Dataspects::SemanticMediaWiki.new(
  @oProfiles,
  "localdataspectssystem",
  @hOptions
)

aRepositoryUrls = [
  "../dataspectsSystemCoreOntology",
  "../dataspectsSystemCookbookOntology"
]

aRepositoryUrls.each do |sRepositoryUrl|
  oDataspectsOntology.use_existing_at_URL(sRepositoryUrl)
  oDataspectsOntology.ajsonObjectURIs.each do |jsonObjectURI|
    # [[NeedsToBeFixed::True]] <<<END
    # This code shall be moved to Dataspects::OntologyRepository.ajsonObjectURIs()
    hObjectURI = JSON.load(jsonObjectURI)
    if(hObjectURI['sObjectName'][-9,9] == '.wikitext')
      oSMW.store_object(jsonObjectURI, "Ontology injection job Lex")
    else
      Dir.glob("#{hObjectURI['sObjectUrl']}/*").each do |sObjectUrl|
        jsonObjectURI = {
          sResourceSiloClass: "Dataspects::OntologyRepository",
          sRepositoryUrl: sRepositoryUrl,
          sObjectClass: "Dataspects::GitRepositoryFile",
          sObjectName: "#{hObjectURI['sObjectName']}:#{File.basename(sObjectUrl)}",
          sObjectUrl: sObjectUrl
        }.to_json
        oSMW.store_object(jsonObjectURI, "dataspectsSystemCoreOntology injection job Lex")
      end
    end
    # END
  end
end
