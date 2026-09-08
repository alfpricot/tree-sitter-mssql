SELECT * FROM OPENDATASOURCE('SQLNCLI', 'Data Source=remote;Integrated Security=SSPI').db.dbo.remote_table;

SELECT ct.sys_change_operation, o.*
FROM CHANGETABLE(CHANGES dbo.orders, @last_sync_version) AS ct
INNER JOIN dbo.orders AS o ON o.order_id = ct.order_id;

SELECT * FROM CHANGETABLE(VERSION dbo.orders, (order_id), (o.order_id)) AS ct;
