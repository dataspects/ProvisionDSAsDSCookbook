oDataspectsCoreOntology = Dataspects::OntologyRepository.new(@oProfiles, @hOptions)
oDataspectsCoreOntology.use_existing_at_URL("../dataspectsSystemCoreOntology")

oSMW = Dataspects::SemanticMediaWiki.new(
  @oProfiles,
  "localmediawiki",
  @hOptions
)

oDataspectsCoreOntology.ajsonObjectURIs.each do |jsonObjectURI|
  oSMW.store_object(jsonObjectURI, "dataspectsSystemCoreOntology injection job Lex")
end
