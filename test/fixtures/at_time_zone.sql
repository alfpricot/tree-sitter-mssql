SELECT order_date AT TIME ZONE 'UTC' AS order_date_utc FROM dbo.orders;

SELECT order_date AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time' AS order_date_eastern
FROM dbo.orders;

SELECT * FROM dbo.orders WHERE order_date AT TIME ZONE 'UTC' > @cutoff;
