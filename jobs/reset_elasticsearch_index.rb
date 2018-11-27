require "./elasticsearch_settings/elasticsearch_index_standard_settings.rb"
require "./elasticsearch_settings/elasticsearch_index_standard_mapping.rb"

sIndexName = 'smwckindex-0'
Dataspects.logMessage("Managing #{sIndexName}")
oSystem = Dataspects::ElasticsearchCluster.new(@oProfiles.returnElasticsearchClusterURL('dataspectsSystemESCluster'))

oSystem.delete_sINDEX(sIndexName)
oSystem.create_sINDEX_with_jsonSETTINGS(sIndexName, @jsonSETTINGS)
oSystem.define_jsonMAPPING_for_sINDEX(@jsonEntitiesIndexMappings, sIndexName)
