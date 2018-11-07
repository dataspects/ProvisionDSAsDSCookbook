odataspectsSystemCoreOntology = Dataspects::OntologyRepository.new(@oProfiles, @hOptions)
odataspectsSystemCoreOntology.create_new_at_URL("/usr/ProvisionDSAsDSCookbook/DEVEXPORT/dataspectsSystemCoreOntology1111")

oDataspectsSystemCookbookOntology = Dataspects::OntologyRepository.new(@oProfiles, @hOptions)
oDataspectsSystemCookbookOntology.create_new_at_URL("/usr/ProvisionDSAsDSCookbook/DEVEXPORT/dataspectsSystemCookbookOntology1111")

#
oSMW = Dataspects::SemanticMediaWiki.new(
  @oProfiles,
  "dataspectsStandardSystemSemanticMediaWiki",
  @hOptions
)

oDSKMFCoreOntologyPages = Dataspects::Facet.new
oDSKMFCoreOntologyPages.from_oSEMANTICMEDIAWIKI(oSMW)
oDSKMFCoreOntologyPages.from_mCATEGORIES("Category:Lex") do |sSMWPageName|
#oDSKMFCoreOntologyPages.from_mNAMESPACES("Main") do |sSMWPageName|
  odataspectsSystemCoreOntology.store_object(
    Dataspects::SemanticMediaWikiPage.new(oSMW, {
        sSMWPageName: sSMWPageName
      }.to_json
    )
  )
end
