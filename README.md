# ShardRemapping
Describes how shard databases can be remapped to a new shard map manager. May be useful if shards are available and shard map manager is missing.

To remap shards to a new shard map manager:
1) Navigate to xConnect of the same version as your shards.
2) Run SqlShardingDeploymentTool like follows to deploy new set of databases (Test4 can be replaced here if needed):
Sitecore.Xdb.Collection.Database.SqlShardingDeploymentTool.exe /operation "create"   /connectionstring "Data Source=.;User Id=sa;Password=12345;Integrated Security=false;Timeout=30" /dbedition "Basic" /shardMapManagerDatabaseName "Test4_Xdb.Collection.ShardMapManager" /shardMapNames "ContactIdShardMap,DeviceProfileIdShardMap,ContactIdentifiersIndexShardMap" /shardnumber 2 /shardnameprefix "Test4_Xdb.Collection.Shard" /shardnamesuffix "" /dacpac "Sitecore.Xdb.Collection.Database.Sql.dacpac"
3) Enable SQLCMD mode in MS SQL Server Management Studio, open the ResetShards.sql, modify the variables and run it.
4) For simpility, sa user can used in the connection strings.
