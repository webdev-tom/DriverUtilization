<cfcomponent>

	<cfsetting requesttimeout="10000">
		
		
		
	<cffunction name="getValidPlants" access="public" returntype="string" hint="returns a string of valid plants/plantids for this report">
		
		<cfquery name="getPlants" datasource="cfweb">
			SELECT
				Company,
				Company_id
			FROM 
				CompanyList
			WHERE
				Company NOT IN ('LouisvilleKY','Columbia')
			
				--Exclude these until further notice
				AND Company NOT IN ('DigitalHighPoint','CoPak')
			ORDER BY 
				Company_id ASC;
		</cfquery>
		
		
		<cfset validPlants = "">
		<cfloop query="getPlants">
			<cfset validPlants &= "#getPlants.Company_id#*#getPlants.Company#,">
		</cfloop>
		<cfset validPlants = Left(validPlants,Len(validPlants)-1)>
			
			
		<cfreturn validPlants >
		
	</cffunction>
		
		
		
	<cffunction name="getTypeaheadData" access="remote" output="yes">
		<cfargument name="ready" required="yes">
			
		<cftry>
			
		<cfset passFail = "pass">
		<cfset reason = "">
			
		<cfif ready eq 1>
			
			<cftransaction>
			<cfquery name="getCustomers" datasource="cfweb">
				SELECT
					csname
  				FROM 
					SALES_GPCustomers 
				WHERE 
					isActive = 1 
				AND
					csname != ''
				GROUP BY
					csname 
				ORDER BY 
					csname asc
			</cfquery>
			</cftransaction>
			
<!---
			<cftransaction>
			<cfquery name="getGrades" datasource="Webview">
				SELECT distinct 
					grade_cd
				FROM QUOTE
				WHERE
					originated_date > DATEADD(month,-18,getDate())
				ORDER BY grade_cd
			</cfquery>
	
			<cfquery name="getStyles" datasource="Webview">
				SELECT distinct 
					REPLACE(style,'"', '') as style
				FROM QUOTE
				WHERE
					originated_date > DATEADD(month,-18,getDate())
				ORDER BY style
			</cfquery>
			</cftransaction>
			
			<cfquery name="getMachines" datasource="Webview">
				SELECT distinct 
					quote.routed_mach_no,
					mc.newmachinename
				FROM quote
				INNER JOIN cfweb.dbo.machine_class mc ON mc.mach_no = quote.routed_mach_no
				WHERE
					originated_date > DATEADD(month,-12,getDate())
				ORDER BY quote.routed_mach_no
			</cfquery>
--->
			
			<cfif getCustomers.recordcount>
				<cfset customersList = ValueList(getCustomers.csname,'*')>
			</cfif>
						
<!---
			<cfif getGrades.recordcount>
				<cfset gradesList = ValueList(getGrades.grade_cd,',')>
			</cfif>
				
			<cfif getStyles.recordcount>
				<cfset stylesList = ValueList(getStyles.style,'*')>
			</cfif>
				
			<cfif getMachines.recordcount>
				<cfset machinesList = ValueList(getMachines.newmachinename,'*')>
			</cfif>
--->
						
		<cfelse>
			<cfset passFail = "fail">
			<cfset reason = "page not ready">
		</cfif>
				
				
<!---		<cfset thisResult = '{"result":"#passFail#","reason":"#reason#","customer_list":"#customersList#","grade_list":"#gradesList#","style_list":"#stylesList#","machine_list":"#machinesList#"}'>--->
			<cfset thisResult = '{"result":"#passFail#","reason":"#reason#","customer_list":"#customersList#"}'>
		<cfoutput>#thisResult#</cfoutput>
			
		<cfcatch>
		<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="ERROR: DriverUtil Typeahead Fail" type="HTML">
			<cfdump var="#cfcatch#">
		</cfmail>
		</cfcatch>
		</cftry>
	</cffunction>
		
		
				
	<!--- SEARCH --->		
	<cffunction name="doSearch" access="remote" output="yes">
		<cfargument name="plant">
		<cfargument name="driver">
		<cfargument name="startDate">
		<cfargument name="endDate">
		<cfargument name="emailCSV">
			
				
		<cfset passFail = 'pass'>
		<cfset reason = ''>
		<cfset thisResult = '{'>
			
		<cftry>
		<!---	custom trailer exclusions
			--AND (tc.descr NOT LIKE '%COMMON%'
			--AND tc.descr NOT LIKE '%CUSTOMER%'
			--AND tc.descr NOT LIKE '%FREIGHT%'
			--AND tc.descr NOT LIKE '%STRAIGHT%'
			--AND tc.descr <> 'COL-ST'
			--AND tc.descr <> '1TN'
			--AND tc.descr <> '93 ST HCK')
		--->
		
		<cftransaction isolation="READ_UNCOMMITTED">
		<cfquery name="getData" datasource="cfweb">
			SELECT
				DLV_DATE,
				Plant,
				Driver_name as driver,
				CARRIER_TRUCK_CD,
				TripNo,
				--Total_SQFT,
				MSF_CFlute_Equiv
			FROM
				IDR_Summary_Driver
			WHERE DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
			AND DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
			<cfif arguments.plant neq "all">
				AND plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
			</cfif> 
			<cfif arguments.driver neq "all">
				AND driver_name = <cfqueryparam value="#arguments.driver#" cfsqltype="CF_SQL_VARCHAR">
			</cfif> 
			ORDER BY
				DLV_DATE,
				Plant,
				CARRIER_TRUCK_CD,
				TripNo
		</cfquery>
		</cftransaction>
			

		<cfif getData.recordcount>
			
			<cfset tableString = "">
			<cfset totalTrips = 0>
			<cfset totalShippedMSF = 0>
				
			<cfloop query="getData">
				
				<cfset theDriver = getData.driver>
				<cfif getData.driver eq "">
					<cfset theDriver = "<i>( driver unassigned from trip )</i>">
				</cfif>
				
				
				<cfif arguments.driver eq "all">
						
					<cfset tableString = tableString & "<tr class='appendedRow' height='40px'><td class='bBorder' width='16.33%' data-sort='" & DateTimeFormat(getData.dlv_date,"yyyymmddHHnnss") & "'><div align='right'>" & DateFormat(getData.dlv_date,"mm/dd/yyyy") & "</div></td><td class='bBorder' width='16.33%'><div align='right' class='mainCol'>" & getData.plant & "</div></td><td class='bBorder' width='16.33%'><div align='right'>" & UCASE(theDriver) & "</div></td><td class='bBorder' width='16.33%'><div align='right'>" & getData.CARRIER_TRUCK_CD & "</div></td><td class='bBorder' width='16.33%'><div align='center'>" & getData.tripno & "</div></td><td class='bBorder' width='16.33%'><div align='left'>" & lsNumberFormat(getData.MSF_CFLUTE_EQUIV,".999") & "</div></td></tr>">
					
				<cfelse>
					
					<cfset tableString = tableString & "<tr class='appendedRow' height='40px'><td class='bBorder' width='16.33%' data-sort='" & DateTimeFormat(getData.dlv_date,"yyyymmddHHnnss") & "'><div align='right'>" & DateFormat(getData.dlv_date,"mm/dd/yyyy") & "</div></td><td class='bBorder' width='16.33%'><div align='right'>" & getData.plant & "</div></td><td class='bBorder' width='16.33%'><div align='right' class='mainCol'>" & UCASE(theDriver) & "</div></td><td class='bBorder' width='16.33%'><div align='right'>" & getData.CARRIER_TRUCK_CD & "</div></td><td class='bBorder' width='16.33%'><div align='center'>" & getData.tripno & "</div></td><td class='bBorder' width='16.33%'><div align='left'>" & lsNumberFormat(getData.MSF_CFLUTE_EQUIV,".999") & "</div></td></tr>">
					
				</cfif>
				
				
					
				<cfset totalTrips += 1>
				<cfset totalShippedMSF += getData.MSF_CFLUTE_EQUIV>

			</cfloop>
					
			<cfset totalShippedMSF = lsNumberFormat(totalShippedMSF,".999")>
					
					
			<cfif emailCSV eq 1>				
				<cfset csvEmailed = createCSV(arguments.plant,arguments.startDate,arguments.endDate)>
					
				<cfif csvEmailed.passFail eq 'pass'>
					<cfset emailSent = 'true'>
				<cfelse>
					<cfset emailSent = 'false'>
					<cfset emailFailMessage = csvEmailed.reason>
						
					<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="idr ship summary CSV errored" type="HTML">
						<br>
						User: Admin
						<br>
						<cfdump var="#csvEmailed#">
					</cfmail>
				</cfif>
			</cfif>
				
					
		<cfelse>
			<cfset tableString = "">
			<cfset totalTrips = 0>
			<cfset totalShippedMSF = 0>
			<cfset passFail = "fail">
			<cfset reason = "No records found.">		
		</cfif>
				

				
		
		<cfset thisResult = thisResult & '"result":"#passFail#","reason":"#reason#","plant":"#arguments.plant#","start_date":"#arguments.startDate#","end_date":"#arguments.endDate#","driver":"#arguments.driver#","total_trips":"#totalTrips#","total_shipped_msf":"#totalShippedMSF#","tableString":"#tableString#"}'>
			
<!---
		<cfset thisResult = '{"result":"#passFail#","reason":"#reason#","search_type":"#SearchType#","table_no":"#arguments.TableNo#","warehouse_no":"#WarehouseNo#","company_no":"#CompanyNo#","sort":"#arguments.sort#","sort_option":"#arguments.SortOption#","total_rows":#totalRows#,"desired_rows":#arguments.desiredRowsFirstLoad#,"current_rows":#arguments.currentRows#,"tableString":"#tableString#"}'>
--->
			
			
<!---
		<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="Someone used the report!" type="HTML">
			<cfdump var="#thisResult#">
		</cfmail>
--->

		<cfoutput>#thisResult#</cfoutput>
			
		<cfcatch>
			<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="ERROR: Driver Utilization Search" type="HTML">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>
		</cftry>

	</cffunction>	
				
				
				
	<cffunction name="getChartData" access="remote" output="yes">
		<cfargument name="plant">
		<cfargument name="startDate">
		<cfargument name="endDate">
		<cfargument name="chartType">
			
				
		<cfset passFail = 'pass'>
		<cfset reason = ''>
		<cfset thisResult = '{'>
			
		<cftry>
			
			
		<cftransaction isolation="READ_UNCOMMITTED">
		<cfswitch expression="#arguments.chartType#">
			
			<cfcase value="DrivTotalMSF">
				<cfquery name="getData" datasource="cfweb">
					SELECT
						<cfif arguments.plant eq 'ALL'>
							'ALL'
						<cfelse>
							Plant
						</cfif> AS Plant,
						COALESCE(NULLIF(Driver_name,''),'Driver Unassigned') as x_data,
						SUM(MSF_CFlute_Equiv) as y_data
					FROM
						IDR_Summary_Driver
					WHERE DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
						
					--Eliminate No Assignment, because majority are warehouse xfers
					AND Driver_name <> 'No Assignment'
						
					and ((DATEPART(dw, DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends
						
					GROUP BY
						<cfif arguments.plant neq 'ALL'>
							Plant,
						</cfif>
						Driver_name
					ORDER BY
						COALESCE(NULLIF(Driver_name,''),'Driver Unassigned'),
						sum(MSF_CFlute_Equiv) desc
				</cfquery>
							
				<cfset yDataName = 'MSF C-Flute Equivalent'>
				<cfset yDataFormat = ".99">
				<cfset chartName = "MSF Shipped: By Driver">
			</cfcase>
				
							
			
			<cfcase value="DrivNumberTrips">
				<cfquery name="getData" datasource="cfweb">
					SELECT
						<cfif arguments.plant eq 'ALL'>
							'ALL'
						<cfelse>
							Plant
						</cfif> AS Plant,
						COALESCE(NULLIF(Driver_name,''),'Driver Unassigned') as x_data,
    					COUNT(Trip_Row_ID) as y_data
					FROM
						IDR_Summary_Driver
					WHERE DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
						
					--Eliminate No Assignment, because majority are warehouse xfers
					AND Driver_name <> 'No Assignment'
						
					and ((DATEPART(dw, DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends
						
					GROUP BY
						<cfif arguments.plant neq 'ALL'>
							Plant,
						</cfif>
						Driver_name
					ORDER BY
						COALESCE(NULLIF(Driver_name,''),'Driver Unassigned'),
						COUNT(Trip_Row_ID) desc
				</cfquery>
							
				<cfset yDataName = 'Number Trips'>
				<cfset yDataFormat = ",">
				<cfset chartName = "Number Trips: By Driver">
			</cfcase>
							
							
			
			<cfcase value="DrivStops">
				<cfquery name="getData" datasource="cfweb">
					SELECT
						<cfif arguments.plant eq 'ALL'>
							'ALL'
						<cfelse>
							Plant
						</cfif> AS Plant,
						COALESCE(NULLIF(Driver_name,''),'Driver Unassigned') as x_data,
						SUM(stops) as y_data
					FROM
						IDR_Summary_Driver
					WHERE DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
						
					--Eliminate No Assignment, because majority are warehouse xfers
					AND Driver_name <> 'No Assignment'
						
					and ((DATEPART(dw, DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends
						
					GROUP BY
						<cfif arguments.plant neq 'ALL'>
							Plant,
						</cfif>
						Driver_name
					ORDER BY
						COALESCE(NULLIF(Driver_name,''),'Driver Unassigned'),
						sum(stops) desc
				</cfquery>
							
				<cfset yDataName = 'Number Stops'>
				<cfset yDataFormat = ",">
				<cfset chartName = "Number Stops: By Driver">
			</cfcase>
							
							
							
			<cfcase value="DrivAvgMSFTrip">
				<cfquery name="getData" datasource="cfweb">
					select a.Plant, a.x_data, AVG(a.y_data) as y_data from (
						SELECT
							<cfif arguments.plant eq 'ALL'>
								'ALL'
							<cfelse>
								Plant
							</cfif> AS Plant,
							COALESCE(NULLIF(Driver_name,''),'Driver Unassigned') as x_data,
							(sum(MSF_CFlute_Equiv) / count(Trip_Row_ID)) as y_data
						FROM
							IDR_Summary_Driver
						WHERE DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
						AND DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
						<cfif arguments.plant neq "all">
							AND plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
						</cfif> 

						--Eliminate No Assignment, because majority are warehouse xfers
						AND Driver_name <> 'No Assignment'
							
						and ((DATEPART(dw, DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends

						GROUP BY
							<cfif arguments.plant neq 'ALL'>
								Plant,
							</cfif>
							Driver_name) a
					GROUP BY
						a.Plant,
						a.x_data
					ORDER BY
						a.x_data,
						AVG(a.y_data) desc
				</cfquery>
								
				<cfset yDataName = 'Average MSF / Trip ( C-Flute Equiv. )'>
				<cfset yDataFormat = ".99">
				<cfset chartName = "Average MSF / Trip: By Driver">
			</cfcase>
					
			<cfcase value="DrivMSFPerDay">
				<cfquery name="getData" datasource="cfweb">
					SELECT
						<cfif arguments.plant eq 'ALL'>
							'ALL'
						<cfelse>
							Plant
						</cfif> AS Plant,
						CONVERT(varchar(10),DLV_DATE,101) as x_data,
						SUM(MSF_CFlute_Equiv) as y_data
					FROM
						IDR_Summary_Driver
					WHERE DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
						
					--Eliminate No Assignment, because majority are warehouse xfers
					AND Driver_name <> 'No Assignment'
						
					and ((DATEPART(dw, DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends
						
					GROUP BY
						<cfif arguments.plant neq 'ALL'>
							Plant,
						</cfif>
						DLV_DATE
					ORDER BY
						DLV_DATE,
						sum(MSF_CFlute_Equiv) desc
				</cfquery>
							
				<cfset yDataName = 'MSF C-Flute Equivalent'>
				<cfset yDataFormat = ".99">
				<cfset chartName = "MSF Shipped (Daily): By Driver">
			</cfcase>
					
					
			<cfcase value="DrivNumberTripsPerDay">
				<cfquery name="getData" datasource="cfweb">
					SELECT
						<cfif arguments.plant eq 'ALL'>
							'ALL'
						<cfelse>
							Plant
						</cfif> AS Plant,
						CONVERT(varchar(10),DLV_DATE,101) as x_data,
						COUNT(Trip_Row_ID) as y_data
					FROM
						IDR_Summary_Driver
					WHERE DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
						
					--Eliminate No Assignment, because majority are warehouse xfers
					AND Driver_name <> 'No Assignment'
						
					and ((DATEPART(dw, DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends
						
					GROUP BY
						<cfif arguments.plant neq 'ALL'>
							Plant,
						</cfif>
						DLV_DATE
					ORDER BY
						DLV_DATE,
						sum(MSF_CFlute_Equiv) desc
				</cfquery>
							
				<cfset yDataName = 'MSF C-Flute Equivalent'>
				<cfset yDataFormat = ".99">
				<cfset chartName = "Number Trips (Daily): By Driver">
			</cfcase>
					
			<!---
			<cfcase value="CustTotalMSF">
				<cfquery name="getData" datasource="cfweb">
					SELECT
						<cfif arguments.plant eq 'ALL'>
							'ALL'
						<cfelse>
							isum.Plant
						</cfif> AS Plant,
						REPLACE(max(cs.csname),',',' ') as x_data,
						sum(isum.MSF_CFlute_Equiv) as y_data
					FROM
						IDR_Summary_Driver isum
					INNER JOIN
						iDelivery.dbo.Delivery_Signatures ds ON isum.trip_row_id = ds.trip_row_id
					LEFT OUTER JOIN
						newccprod2.cc.dbo.customer cs ON ds.cscode = cs.cscode
					WHERE isum.DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND isum.DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND isum.plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
						
					--Eliminate No Assignment, because majority are warehouse xfers
					AND isum.Driver_name <> 'No Assignment'
						
					GROUP BY
						<cfif arguments.plant neq 'ALL'>
							isum.Plant,
						</cfif>
						ds.cscode
					ORDER BY
						REPLACE(max(cs.csname),',',' '),
						sum(isum.MSF_CFlute_Equiv) desc
				</cfquery>
							
				<cfset yDataName = 'MSF C-Flute Equivalent'>
				<cfset yDataFormat = ".99">
				<cfset chartName = "MSF Shipped: By Customer">
			</cfcase>
							
							
							
			<cfcase value="CustNumberTrips">
				<cfquery name="getData" datasource="cfweb">
					SELECT
						<cfif arguments.plant eq 'ALL'>
							'ALL'
						<cfelse>
							isum.Plant
						</cfif> AS Plant,
						REPLACE(max(cs.csname),',',' ') as x_data,
    					COUNT(distinct isum.trip_row_id) as y_data
					FROM
						IDR_Summary_Driver isum
					INNER JOIN
						iDelivery.dbo.Delivery_Signatures ds ON isum.trip_row_id = ds.trip_row_id
					LEFT OUTER JOIN
						newccprod2.cc.dbo.customer cs ON ds.cscode = cs.cscode
					WHERE isum.DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND isum.DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND isum.plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
						
					--Eliminate No Assignment, because majority are warehouse xfers
					AND isum.Driver_name <> 'No Assignment'
						
					GROUP BY
						<cfif arguments.plant neq 'ALL'>
							isum.Plant,
						</cfif>
						ds.cscode
					ORDER BY
						REPLACE(max(cs.csname),',',' '),
						COUNT(distinct isum.trip_row_id) desc
				</cfquery>
							
				<cfset yDataName = 'Number Trips'>
				<cfset yDataFormat = ",">
				<cfset chartName = "Number Trips: By Customer">
			</cfcase>	
			--->
					
					
					
					
					
				
					
			
			<cfcase value="DateAvgMSFDriver">
				<cfquery name="getData" datasource="cfweb">
				SELECT
					driver_plant AS Plant,
					CONVERT(varchar(10),DLV_DATE,101) as x_data,
					ROUND(COALESCE(sum(msf_cflute_equiv),-1) / COALESCE(count(distinct isd.driver_name),-1),0) as y_data
				FROM IDR_Summary_Driver isd
				INNER JOIN CompanyList cl ON cl.Company_ID = isd.driver_plantno
				where 
					isd.DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND isd.DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND driver_plantno = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
					and isd.Warehousexfer_trip_flag = 0
					and isd.driver_plant is not null
					and isd.plant not in ('DigitalHighPoint','CoPak')
					and ((DATEPART(dw, DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends
				group by dlv_date,driver_plant
				order by  max(cl.DefaultSort)
				</cfquery>
							
				<cfset yDataName = 'MSF C-Flute Equivalent'>
				<cfset yDataFormat = ".99">
				<cfset chartName = "Avg MSF/Driver: By Date">
			</cfcase>
					
					
					
			<cfcase value="DateAvgMSFTrip">
				<cfquery name="getData" datasource="cfweb">
				SELECT
					driver_plant AS Plant,
					CONVERT(varchar(10),DLV_DATE,101) as x_data,
					ROUND(COALESCE(sum(msf_cflute_equiv),-1) / COALESCE(count(tripno),-1),0) as y_data
				FROM IDR_Summary_Driver isd
				INNER JOIN CompanyList cl ON cl.Company_ID = isd.driver_plantno
				where 
					isd.DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND isd.DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND driver_plantno = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
					and isd.Warehousexfer_trip_flag = 0
					and isd.driver_plant is not null
					and isd.plant not in ('DigitalHighPoint','CoPak')
					and ((DATEPART(dw, DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends
				group by dlv_date,driver_plant
				order by  max(cl.DefaultSort)
				</cfquery>
							
				<cfset yDataName = 'MSF C-Flute Equivalent'>
				<cfset yDataFormat = ".99">
				<cfset chartName = "Avg MSF/Trip: By Date">
			</cfcase>
					
					
				
			<cfcase value="DateAvgMilesDriver">
				<cfquery name="getData" datasource="cfweb">
				SELECT
					driver_plant AS Plant,
					CONVERT(varchar(10),isd.DLV_DATE,101) as x_data,
					ROUND(COALESCE(sum(distinct miles_traveled),-1) / COALESCE(count(distinct isd.driver_name),-1),0) as y_data
				FROM IDR_Summary_Driver isd
				--LEFT OUTER JOIN idelivery.dbo.DELIVERY_DriverLog ddl ON ddl.drivercode = isd.kellerDriverCode and ddl.dlv_date = isd.dlv_date
				INNER JOIN CompanyList cl ON cl.Company_ID = isd.driver_plantno
				where 
					isd.DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND isd.DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND driver_plantno = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
					and isd.Warehousexfer_trip_flag = 0
					and isd.driver_plant is not null
					and isd.plant not in ('DigitalHighPoint','CoPak')
					and ((DATEPART(dw, isd.DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends
				group by isd.dlv_date,driver_plant
				order by  max(cl.DefaultSort)
				</cfquery>
							
				<cfset yDataName = 'Miles'>
				<cfset yDataFormat = ".99">
				<cfset chartName = "Avg Miles/Driver: By Date">
			</cfcase>
					
					
					
			<cfcase value="DateAvgTripDriver">
				<cfquery name="getData" datasource="cfweb">
				SELECT
					driver_plant AS Plant,
					CONVERT(varchar(10),DLV_DATE,101) as x_data,
					ROUND(COALESCE(CAST(count(tripno) as decimal(4,2)),-1) / COALESCE(count(distinct isd.driver_name),-1),1) as y_data
				FROM IDR_Summary_Driver isd
				INNER JOIN CompanyList cl ON cl.Company_ID = isd.driver_plantno
				where 
					isd.DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
					AND isd.DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
					<cfif arguments.plant neq "all">
						AND driver_plantno = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
					</cfif> 
					and isd.Warehousexfer_trip_flag = 0
					and isd.driver_plant is not null
					and isd.plant not in ('DigitalHighPoint','CoPak')
					and ((DATEPART(dw, DLV_DATE) + @@DATEFIRST) % 7) NOT IN (0,1) --exclude weekends
				group by dlv_date,driver_plant
				order by  max(cl.DefaultSort)
				</cfquery>
							
				<cfset yDataName = 'Trips'>
				<cfset yDataFormat = ".99">
				<cfset chartName = "Avg Trip/Driver: By Date">
			</cfcase>
					

			
		</cfswitch>
		</cftransaction>
			

		<cfif getData.recordcount>
			
			
			<cfset dataObj = '[{"name":"#getData.Plant#", "data":['>
			<cfset xArr = '['>
			
			<cfif arguments.plant eq 'all' AND (LEFT(arguments.chartType,4) eq 'Date')>
				
				
				<cfset lastPlant = getData.Plant>
				<cfset collectXFlag = 1>
				<cfloop query="getData">
					<cfif getData.currentrow eq getData.recordcount>
						<cfset dataObj &= '#lsNumberFormat(getData.y_data,yDataFormat)#]}]'>
						<cfif collectXFlag eq 1>
							<cfset xArr &= '"#getData.x_data#"]'>
						</cfif>
							
					<cfelseif getData.Plant neq lastPlant>
						<cfset dataObj = Left(dataObj,Len(dataObj)-1)>
						<cfset dataObj &= ']},{"name":"#getData.Plant#", "data":[#lsNumberFormat(getData.y_data,yDataFormat)#,'>
						<cfif collectXFlag eq 1>
							<cfset xArr = Left(xArr,Len(xArr)-1)>
							<cfset xArr &= ']'>
							<cfset collectXFlag = 0>
						</cfif>
							
					<cfelse>
						<cfset dataObj &= '#lsNumberFormat(getData.y_data,yDataFormat)#,'>
						<cfif collectXFlag eq 1>
							<cfset xArr &= '"#getData.x_data#",'>
						</cfif>
						
					</cfif>
							
					<cfset lastPlant = getData.Plant>
				</cfloop>
				
					
			<cfelse>
				
				
				<cfset dataObj = '[{"name":"#yDataName#", "data":['>
				
				
				<cfloop query="getData">
					<cfif getData.currentrow eq getData.recordcount>
						<cfset dataObj &= '#lsNumberFormat(getData.y_data,yDataFormat)#]}]'>
						<cfset xArr &= '"#getData.x_data#"]'>
					<cfelse>
						<cfset dataObj &= '#lsNumberFormat(getData.y_data,yDataFormat)#,'>
						<cfset xArr &= '"#getData.x_data#",'>
					</cfif>
				</cfloop>
				
			</cfif>
							
			
			<cfif arguments.plant eq 'all'>
				<cfset thisPlant = 'All Plants'>
			<cfelse>
				<cfset thisPlant = getData.plant>
			</cfif>
			
					
		<cfelse>
			<cfset dataObj = "">
			<cfset thisPlant = "">
			<cfset xArr = "">
			<cfset passFail = "fail">
			<cfset reason = "No records found.">		
		</cfif>
				
				
		
		<cfset thisResult = thisResult & '"result":"#passFail#","reason":"#reason#","this_plant":"#thisPlant#","chart_name":"#chartName#","x_arr":#xArr#,"data_obj":#dataObj#}'>
			


		<cfoutput>#thisResult#</cfoutput>
			
		<cfcatch>
			<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="ERROR: Driver Utilization getChartData" type="HTML">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>
		</cftry>

	</cffunction>				
				
	
			
				
				
				
				
				
	<!--- CREATE CSV: called internally from doSearch --->	
	<cffunction name="createCSV" access="private" output="yes">
		<cfargument name="plant" required="yes">
		<cfargument name="startDate" required="yes">
		<cfargument name="endDate" required="yes">

			
		<cfset result = StructNew()>
		<cfset result['passFail'] = 'pass'>
		<cfset result['reason'] = ''>
			
		<cftry>
			
			
		
		<cftransaction isolation="READ_UNCOMMITTED">
		<cfquery name="getCSVData" datasource="iDelivery">
			SELECT
				DLV_DATE,
				Plant,
				Driver_name as driver,
				CARRIER_TRUCK_CD,
				TripNo,
				--Total_SQFT,
				MSF_CFlute_Equiv
			FROM
				IDR_Summary_Driver
			WHERE DLV_DATE >= <cfqueryparam value="#arguments.startDate#" cfsqltype="CF_SQL_VARCHAR">
			AND DLV_DATE <= <cfqueryparam value="#arguments.endDate#" cfsqltype="CF_SQL_VARCHAR">
			AND plantid = <cfqueryparam value="#arguments.plant#" cfsqltype="CF_SQL_VARCHAR">
			ORDER BY
				DLV_DATE,
				Plant,
				MSF_CFlute_Equiv desc,
				driver
		</cfquery>
		</cftransaction>
			
				
		<cfset csvfile = "DlvDate,Plant,Driver,TripNo,Trailer,MSF_CFLUTE_EQUIV" & chr(13)>
			
					
		<cfif getDriverUtilData.recordcount>
			<cfloop query="getDriverUtilData">
				<cfset csvrow = 
					DateFormat(getDriverUtilData.dlv_date,"mm/dd/yyyy") &','&
					getDriverUtilData.plant &','&
					UCASE(REReplaceNoCase(REReplaceNoCase( getDriverUtilData.driver ,"[^a-z0-9]" , " " , "all" ), chr(34), "", "all")) &','&
					getDriverUtilData.tripno &','&
					UCASE(REReplaceNoCase(REReplaceNoCase( getDriverUtilData.CARRIER_TRUCK_CD ,"[^a-z0-9]" , " " , "all" ), chr(34), "", "all")) &','&
					getDriverUtilData.total_sqft &','&
					getDriverUtilData.msf_cflute_equiv
				   >
				<cfset csvfile = csvfile & csvrow & chr(10)>
			</cfloop>
		<cfelse>
			<cfset result['passFail'] = 'fail'>
			<cfset result['reason'] = 'No records found...'>
		</cfif>
				
		
		
			
		
		<cfset CSVFileName =  'IDRDriverUtil_#DateFormat(arguments.startDate,"mm-dd-yyyy")#__#DateFormat(arguments.endDate,"mm-dd-yyyy")#.csv' > 

		<cfset messageSubject =  'IDR Driver Utilization CSV: #DateFormat(arguments.startDate,"mm/dd/yyyy")# - #DateFormat(arguments.endDate,"mm/dd/yyyy")#' >

				
		
		<cfset CSVFileName =  'IDRDriverUtil_#DateFormat(arguments.startDate,"mm-dd-yyyy")#__#DateFormat(arguments.endDate,"mm-dd-yyyy")#.csv' > 

		<cfset CSVFileName =  GetDirectoryFromPath(ExpandPath("*.*")) & 'Files\' & CSVFileName> 
		<cffile action="write" file="#CSVFileName#" output="#csvfile#" addnewline="yes" nameconflict="overwrite">
		
		   
		
		<cfif fileexists(CSVFileName)>
		
		    <cfmail to="dev@tomfafard.com" bcc="dev@tomfafard.com" from="webservices@carolinacontainer.com" subject="#messageSubject#" >
			<cfmailparam file="#CSVFileName#">
			To Open this file: 
			First, save this attachment to your hard drive.
			Next, open a tool that can parse this csv file
			( comma separated values ) such as Microsoft Excel.
			From 'within' this program, choose open from the 
			file menu and point it to the just saved file.

			Please do not reply to this automated email.
			</cfmail>

		</cfif>       
			
		
		<cfreturn result>
		
			
		<cfcatch>
			<cfmail to="dev@tomfafard.com" from="dev@tomfafard.com" subject="ERROR:Driver Util CSV" type="HTML">
				<cfdump var="#cfcatch#">
			</cfmail>
		</cfcatch>
		</cftry>
			
	</cffunction>

			
		

	<cffunction name="GetDateByWeek" access="private" returntype="date" output="false">
		<cfargument name="Year" type="numeric" required="true">
		<cfargument name="Week" type="numeric" required="true">


		<!---
			Get the first day of the year. This one is
			easy, we know it will always be January 1st
			of the given year.
		--->
		<cfset FirstDayOfYear = CreateDate(arguments.Year, 1, 1)>

		<!---
			Based on the first day of the year, let's
			get the first day of that week. This will be
			the first day of the calendar year.
		--->
		<cfset FirstDayOfCalendarYear = ( FirstDayOfYear - DayOfWeek( FirstDayOfYear ) + 1 )>

		<!---
			Now that we know the first calendar day of
			the year, all we need to do is add the
			appropriate amount of weeks. Weeks are always
			going to be seven days.
		--->
		<cfset FirstDayOfWeek = ( FirstDayOfCalendarYear + ( (arguments.Week - 1) * 7 ) )>


		<!---
			Return the first day of the week for the
			given year/week combination. Make sure to
			format the date so that it is not returned
			as a numeric date (this will just confuse
			too many people).
		--->
		<cfreturn DateFormat(FirstDayOfWeek, "yyyy-mm-dd")>
	</cffunction>
				
								
</cfcomponent>