oDataspectsCoreOntology = Dataspects::OntologyRepository.new(
  @oProfiles,
  "/usr/src/dataspectsSystemCoreOntology",
  @hOptions
)

oDataspectsSystemCookbook = Dataspects::OntologyRepository.new(
  @oProfiles,
  "/usr/src/dataspectsSystemCookbookOntology",
  @hOptions
)

oSMW = Dataspects::SemanticMediaWiki.new(
  @oProfiles,
  "dataspectsStandardSystemSemanticMediaWiki",
  @hOptions
)

oDataspectsCoreOntology.ajsonObjectURIs.each do |jsonObjectURI|
  oSMW.store_object(jsonObjectURI, "dataspectsSystemCoreOntology injection job Lex 23.10.2018")
end

oDataspectsSystemCookbook.ajsonObjectURIs.each do |jsonObjectURI|
  oSMW.store_object(jsonObjectURI, "dataspectsSystemCookbook injection job Lex 23.10.2018")
end
