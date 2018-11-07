oDataspectsCoreOntology = Dataspects::OntologyRepository.new(@oProfiles, @hOptions)
oDataspectsCoreOntology.use_existing_at_URL("/usr/ProvisionDSAsDSCookbook/DEVEXPORT/dataspectsSystemCoreOntology1111")

oDataspectsSystemCookbook = Dataspects::OntologyRepository.new(@oProfiles, @hOptions)
oDataspectsSystemCookbook.use_existing_at_URL("/usr/src/dataspectsSystemCookbookOntology")

oSMW = Dataspects::SemanticMediaWiki.new(
  @oProfiles,
  "dataspectsStandardSystemSemanticMediaWiki",
  @hOptions
)

oDataspectsCoreOntology.ajsonObjectURIs.each do |jsonObjectURI|
  oSMW.store_object(jsonObjectURI, "dataspectsSystemCoreOntology injection job Lex 23.10.2018")
end

# oDataspectsSystemCookbook.ajsonObjectURIs.each do |jsonObjectURI|
#   oSMW.store_object(jsonObjectURI, "dataspectsSystemCookbook injection job Lex 23.10.2018")
# end
