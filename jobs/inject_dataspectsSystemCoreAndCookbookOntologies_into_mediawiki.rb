oDataspectsCoreOntology = Dataspects::OntologyRepository.new(@oProfiles, @hOptions)
oDataspectsCoreOntology.use_existing_at_URL("/usr/dataspectsSoftware/dataspectsSystemCoreOntology")

oDataspectsSystemCookbook = Dataspects::OntologyRepository.new(@oProfiles, @hOptions)
oDataspectsSystemCookbook.use_existing_at_URL("/usr/dataspectsSoftware/dataspectsSystemCookbookOntology")

oSMW = Dataspects::SemanticMediaWiki.new(
  @oProfiles,
  "localmediawiki",
  @hOptions
)

oDataspectsCoreOntology.ajsonObjectURIs.each do |jsonObjectURI|
  oSMW.store_object(jsonObjectURI, "dataspectsSystemCoreOntology injection job Lex 23.10.2018")
end

oDataspectsSystemCookbook.ajsonObjectURIs.each do |jsonObjectURI|
  oSMW.store_object(jsonObjectURI, "dataspectsSystemCookbook injection job Lex 23.10.2018")
end
