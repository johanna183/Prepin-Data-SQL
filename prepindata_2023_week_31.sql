WITH dim AS 
	(SELECT 
		[employee_id]
		,[guid]
	FROM [dbo].[ee_dim_input] 
	WHERE [employee_id] != '' AND
	[guid] != ''
	)

,mon AS 
	(SELECT 
		[employee_id]
		,[guid]
	FROM [dbo].[ee_monthly_input]
	WHERE [employee_id] != '' AND
	[guid] != ''
	)

,lookup_table AS
	(SELECT * FROM dim
	UNION 
	SELECT * FROM mon
	)

,dim_replace_guid AS
	(SELECT 
		D.[employee_id]
		,L.[guid]
		,D.[first_name]
		,D.[last_name]
		,D.[date_of_birth]
		,D.[nationality]
		,D.[gender]
		,D.[email]
		,D.[hire_date]
		,D.[leave_date]
	FROM [dbo].[ee_dim_input] AS D
	INNER JOIN lookup_table AS L
	ON D.[employee_id] = L.[employee_id]
	)

,dim_replace_id AS
	(SELECT 
		L.[employee_id]
		,D.[guid]
		,D.[first_name]
		,D.[last_name]
		,D.[date_of_birth]
		,D.[nationality]
		,D.[gender]
		,D.[email]
		,D.[hire_date]
		,D.[leave_date]
	FROM [dbo].[ee_dim_input] AS D
	INNER JOIN lookup_table AS L
	ON D.[guid] = L.[guid]
	)

,mon_replace_guid AS
	(SELECT 
		M.[dc_nbr]
		,M.[month_end_date]
		,M.[employee_id]
		,L.[guid]
		,M.[hire_date]
		,M.[leave_date]
	FROM [dbo].[ee_monthly_input] AS M
	INNER JOIN lookup_table AS L
	ON M.[employee_id] = L.[employee_id]
	)

,mon_replace_id AS
	(SELECT 
		M.[dc_nbr]
		,M.[month_end_date]
		,L.[employee_id]
		,M.[guid]
		,M.[hire_date]
		,M.[leave_date]
	FROM [dbo].[ee_monthly_input] AS M
	INNER JOIN lookup_table AS L
	ON M.[guid] = L.[guid]
	)

,dim_final AS
	(SELECT * FROM 
	dim_replace_guid 
	UNION
	SELECT * FROM 
	dim_replace_id 
	)

,mon_final AS
	(SELECT * FROM
	mon_replace_guid
	UNION
	SELECT * FROM 
	mon_replace_id
	)

--- SELECT * FROM dim_final

SELECT * FROM mon_final
