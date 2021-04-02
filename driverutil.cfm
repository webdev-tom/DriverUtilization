<cfparam name="startDate" default="#DateFormat(DateAdd('d',-1,now()), 'mm/dd/yyyy')#">
<cfparam name="endDate" default="#DateFormat(now(),'mm/dd/yyyy')#">
	
	
<cftry>	
	
<!--- If Monday start search last Friday --->
<cfif DayOfWeek(endDate) eq 2>
	<cfset startDate = DateFormat(DateAdd("d",-3,now()),"mm/dd/yyyy")>
</cfif>
	

	
<!--- define component --->
<cfset driverutil = CreateObject("component","driverutil_CFC")>

	

<cfquery name="getDrivers" datasource="cfweb">
	SELECT DISTINCT
		Driver_name
	FROM 
		IDR_Summary_Driver
	ORDER BY 
		Driver_name;
</cfquery>

	
	

<html>
<head>
<meta charset="UTF-8">
<title>Driver Utilization Demo | tomfafard.com</title>
	

<!--- driverutil CSS --->
<link href="driverutil.css" rel="stylesheet">


<link href="/includes/plugins/bootstrap3/css/bootstrap.min.css" rel="stylesheet">
<link href="/includes/plugins/basicTypeahead/jquery.typeahead.min.css" rel="stylesheet">
<link href="/includes/plugins/fontawesome/css/all.min.css" rel="stylesheet">
<link href="/includes/plugins/datetimepicker/jquery.datetimepicker.css" rel="stylesheet">
<link href="/includes/plugins/webui-popover/dist/jquery.webui-popover.css" rel="stylesheet">
<link href="/includes/plugins/DataTables_Old/datatables.min.css" rel="stylesheet">
<link href="/includes/plugins/timelinejs/timeline.min.css" rel="stylesheet">
</head>
<body>
<cfoutput>
	
	<!--- BEGIN NAV --->
	
	<nav class="navbar navbar-default navbar-fixed-top">
	  <div class="container-fluid">
		<div class="navbar-header">
			<a href="https://tomfafard.com">
			<img id="brand-image" alt="Brand" src="/includes/images/projects/shared/logo.png" draggable="false">
		  	</a>
		</div>
	  </div>
		<div class="top-menu">
			<ul class="nav navbar-nav pull-right" style="margin-right: 560px">
				<li id="nav-right" style="position: static">
					<div id="introPanel"></div>
					<div id="reportTitleDiv" class="btn-group">
						<h1 id="reportTitle" class="noselect dropdown-toggle hoverspinner" data-toggle="dropdown">
							 <i id="titleIcon" class="fas fa-truck" style="display: none"></i> <span>Driver Utilization</span></h1>
						<ul id="reportMenu" class="dropdown-menu hoverspinner" role="menu">
							<li><a href="##" data-location="driverutil"><i class="fas fa-truck"></i> Driver Utilization</a></li>
							<li><a href="##"><i class="fas fa-users"></i> Customer Utilization</a></li>
							<li><a href="##"><i class="fas fa-warehouse"></i> Warehouse Xfer Report</a></li>
						</ul>
						<div class="loader" style="position: absolute;left: 40.5%"><img src="/includes/images/projects/shared/blue_loading.png"></div>
					</div>
				</li>
			</ul>
		</div>
	</nav>
	
	<!--- END NAV --->
	
	
	
	
	<!--- BEGIN MAIN CONTAINER --->
	
	<div class="container" style="padding-top: 60px; width: auto !important;">
		<div id="inputRow" class="row">
			<div class="col-sm-12">
				
				<img src="/includes/images/projects/DriverUtilization/switchReport.gif" width="110px" id="switchImg">
				

				<div id="emailConfirm" class="noselect" style="display: none"><i class="fas fa-exclamation-circle"></i> CSV sent to your inbox</div>
				<div id="reportFilterFormDiv" class="form-group">
					<form action="driverutil.cfm" method="put" name="reportFilterForm" id="reportFilterForm">
						
						<h4 id="searchHeader" class="noselect">select plant:</h4>

					
						<div id="plantDiv" class="selectStyle">

							<select id="plantSelect" class="form-control" name="plant">
								<cfloop list="#driverutil.getValidPlants()#" index="IDPlant" delimiters=",">
									<option value="#ListToArray(IDPlant,'*')[1]#">#ListToArray(IDPlant,'*')[2]#</option>
								</cfloop>
								<option value="all">ALL</option>
							</select>
						</div>
						
						<div id="driverDiv" class="selectStyle" style="width: 150px !important">
							<h4 id="driverHeader" class="noselect" style="position: absolute;top: 0px">select driver:</h4>
							<select id="driverSelect" class="form-control" name="driver">
								<option value="all">all drivers</option>
								<cfloop query="getDrivers">
									<cfif getDrivers.driver_name eq "">
										<option value="">( driver unassigned )</option>
									<cfelse>
										<option value="#getDrivers.driver_name#">#getDrivers.driver_name#</option>
									</cfif>
								</cfloop>
							</select>
						</div>
						
						
						<div id="dateRangeDiv" class="inputStyle form-inline" style="display: inline-flex">
							<h4 id="rangeHeader" class="noselect" style="position: absolute;top: 0px">delivered between:</h4>
							<input type="text" id="dateStartInput" class="form-control" name="startDate" value="#startDate#" maxlength="10" placeholder="start" autocomplete="off" spellcheck="false" style="width: 100px !important">
							<input type="text" id="dateEndInput" class="form-control" name="endDate" value="#endDate#" maxlength="10" placeholder="end" autocomplete="off" spellcheck="false" style="margin-left: 4px; width: 100px !important">
						</div>
						
						<div class="searchButtonGroup">
							<div id="submitDiv">
								<button type="submit" id="submitBtn" class="btn">Search <i class="fas fa-arrow-right"></i></button>
							</div>
						</div>
							
<!---						<a href="##filterModal" id="displayFilterToggle" data-toggle="modal"><i class="fas fa-plus"></i> <span>advanced search</span></a>--->
						
<!---
						<div id="csvDiv" class="form-inline" style="padding-top: 5px;padding-left: 10px;display: none">
							<div id="emailCSVDiv" class="form-inline" style="display: inline-flex">
							<input type="checkbox" id="emailCSV" name="emailCSV" value="true">
							<label for="emailCSV"><i class="fas fa-envelope"></i> Email CSV</label>
							</div>
--->
<!---
							<div id="includeAmtechContainer" style="display: none">
								<input type="checkbox" id="includeAmtech" name="includeAmtech" value="true">
								<label for="includeAmtech"><i class="fas fa-clipboard-list"></i> Include Amtech data?</label>
							</div>
							<div id="driverUtilContainer" style="padding-left: 15px; display: inline-flex">
								<input type="checkbox" id="includeDriverUtil" name="includeDriverUtil" value="true">
								<label for="includeDriverUtil"><i class="fas fa-users"></i> Driver Util.</label>
							</div>
--->
<!---						</div>--->
						
<!---
						<div id="TableStyleContainer" class="form-inline">
							<select id="TableStyleSelect" name="TableStyleSelect" class="form-control" style="width: 200px !important;">
								<option value="2" selected>by Item</option>
								<option value="1">by Ticket</option>
							</select>
						</div>
--->
						
						<!--- <div id="seachFilterGroup" style="display: inline-flex;position: absolute;margin-left: 4px"> --->
<!---
						
						<div id="searchFilterGroup" style="display: inline-flex;position: absolute;margin-left: 4px;z-index: 999">
							<div id="searchFilterOneContainer" class="searchFilterStyle form-inline" style="display: none">
								<h4 class="filterHeader noselect">filter one:</h4>
								<input id="searchFilterOne" name="searchFilterOne" class="searchFilterInput form-control">
								<div class="form-inline">
									<select class="searchFilterSelect form-control" id="searchFilterSelectOne" name="searchFilterSelectOne">
										<option value="OrderNo">Order Number</option>
										<option value="ItemNo">Item Number</option>
										<option value="ItemDescr">Item Description</option>
									</select>
									<button type="button" id="searchFilterOneRemove" class="btn"><i class="far fa-trash-alt"></i></button>
								</div>
							</div>

							<div id="searchFilterTwoContainer" class="searchFilterStyle form-inline" style="display: none">
								<h4 class="filterHeader noselect">filter two:</h4>
								<input id="searchFilterTwo" name="searchFilterTwo" class="searchFilterInput form-control">
								<div class="form-inline">
									<select class="searchFilterSelect form-control" id="searchFilterSelectTwo" name="searchFilterSelectOne">
										<option value="OrderNo">Order Number</option>
										<option value="ItemNo">Item Number</option>
										<option value="ItemDescr">Item Description</option>
									</select>
									<button type="button" id="searchFilterTwoRemove" class="btn"><i class="far fa-trash-alt"></i></button>
								</div>
							</div>
						</div>
--->
						
<!---
						<div id="companyDiv" class="inputStyle" style="display: none">
							<select id="companyInput" name="company" class="form-control">
								<cfloop query="getCompany">
									<option value="#getCompany.company_id#">#getCompany.company_id# | #getCompany.company#</option>
								</cfloop>
							</select>
						</div>
--->
	
<!---
						<a href="##checkFilters" id="displayFilterToggle" data-toggle="collapse"><i class="fas fa-plus"></i> <span>more options</span></a>
						<div id="checkFilters" class="noselect collapse">

							
							
							<input type="checkbox" id="emailCSV" name="emailCSV" value="true">
							<label for="emailCSV">Email Detail CSV</label>
							<div id="includeAmtechContainer" style="display: none">
								<input type="checkbox" id="includeAmtech" name="includeAmtech" value="true">
								<label for="includeAmtech">Include Amtech data?</label>
							</div>


						</div>
--->
					</form>
				</div>
			</div>
		</div> <!--- inputRow --->
			
			
		
		
		<div id="notifyBox">
			<span id="notifyMessage"></span>
		</div>
			
		
		<div id="resultRow" class="row">
			<div class="col-sm-12" >
				<div style="position: absolute; left: 50%; top: 17vh">
					<div class="loaderDiv" style="position: relative; left: -50%; text-align: center;display: none">
						<div class="loader"><img src="/includes/images/projects/shared/blue_loading.png"></div>
						<span id="loader-label" class="noselect"><span id="loaderText">Getting data</span> <span class="loader__dot">.</span><span class="loader__dot">.</span><span class="loader__dot">.</span></span>
					</div>
				  </div>
				
				
					<!--- !!Remove class container below to stretch the full width of cols --->
				<div id="reportTabs" class="container" style="margin-top: 20px;display: none">	
					<ul  class="nav nav-tabs nav-justified">
						<li class="active">
							<a  href="##1a" data-toggle="tab"><span id="tabhdr1" class="tabtitle">Results: Unique Trips by Driver</span></a>
						</li>
						<li>
							<a href="##2a" data-toggle="tab"><span id="tabhdr2" class="tabtitle">Utilization Graphs</span></a>
						</li> 
					</ul>

					<div class="tab-content clearfix">
						<div class="tab-pane active" id="1a">
							<div id="resultDiv" style="margin-top: 10px">
								<div id="resultTableDiv"></div>
				  			</div>
						</div>
						<div class="tab-pane" id="2a" style="padding-top: 10px">
							<span style="font-weight: bold;background-color: rgba(254, 255, 55,0.5)">Graph:</span>
							<div id="chartSelect">
								<div class="btn-group">
									<button type="button" class="form-control btn btn-default dropdown-toggle" data-toggle="dropdown">
										<span id="selectedChart">MSF Shipped: by Driver</span> <span class="caret"></span>
									</button>
									<ul id="chartMenu" class="dropdown-menu" role="menu">
										
										<li><a href="##" data-showdiv="DrivTotalMSFDiv">MSF Shipped: by Driver</a></li>
										<li><a href="##" data-showdiv="DrivNumberTripsDiv">Number Trips: by Driver</a></li>
										<li><a href="##" data-showdiv="DrivStopsDiv">Number Stops: by Driver</a></li>
										<li><a href="##" data-showdiv="DrivAvgMSFTripDiv">Average MSF / Trip: by Driver</a></li>
										<!---
											<li style="border-top: 1px solid ##ddd"><a href="##" data-showdiv="DrivMSFPerDayDiv">MSF Shipped (Daily): by Driver</a></li>
											<li><a href="##" data-showdiv="DrivNumberTripsPerDayDiv">Number Trips (Daily): by Driver</a></li>
										--->
										
										
										<li style="border-top: 1px solid ##ddd"><a href="##" data-showdiv="DateAvgMSFDriverDiv">Average MSF / Driver: by Date</a></li>
										<li><a href="##" data-showdiv="DateAvgMSFTripDiv">Average MSF / Trip: by Date</a></li>
										<li><a href="##" data-showdiv="DateAvgMilesDriverDiv">Average Miles / Driver: by Date</a></li>
										<li><a href="##" data-showdiv="DateAvgTripDriverDiv">Average Trip / Driver: by Date</a></li>

										
									</ul>
								</div>
							</div>
							
							<img src="/includes/images/projects/DriverUtilization/exportGraph2.gif" width="85px"  id="graphImg">
							

							
							<!---
									Graph Sort

								<span style="font-weight: bold;margin-left:10px">Order:</span>
								<div id="sortSelect" style="display: inline">
									<div class="btn-group">
										<button type="button" class="form-control btn btn-default dropdown-toggle" data-toggle="dropdown">
											<span id="selectedSort">A-Z</span> <span class="caret"></span>
										</button>
										<ul id="sortMenu" class="dropdown-menu" role="menu">

											<li><a href="##" id="sortAZ">A-Z</a></li>
											<li><a href="##" id="sortMinMax">Min-Max</a></li>
											<li><a href="##" id="sortMaxMin">Max-Min</a></li>

										</ul>
									</div>
								</div>


							--->
							

						 	
								<div id="DrivTotalMSFDiv" class="chartDiv activeChart"></div>
				  			
								<div id="DrivNumberTripsDiv" class="chartDiv"></div>
				  		
								<div id="DrivStopsDiv" class="chartDiv"></div>
							
								<div id="DrivAvgMSFTripDiv" class="chartDiv"></div>
							
								<!---
									<div id="DrivMSFPerDayDiv" class="chartDiv"></div>


									<div id="DrivNumberTripsPerDayDiv" class="chartDiv"></div>
								--->
							
							
							
							
								<div id="DateAvgMSFDriverDiv" class="chartDiv"></div>
							
								<div id="DateAvgMSFTripDiv" class="chartDiv"></div>

								<div id="DateAvgMilesDriverDiv" class="chartDiv"></div>

								<div id="DateAvgTripDriverDiv" class="chartDiv"></div>
						


							
						</div>
					</div>
				  </div>				
		
			</div>	
<!---
			<div class="col-sm-3">
			
				<div id="tripDetailContainer">
				
					Testing
				
				</div>
			
			</div>
--->
		</div> <!--- resultRow --->
	</div> <!--- container --->
		
	<!--- END MAIN CONTAINER --->
		
		
	
	
	
	<!--- BEGIN MODALS --->
		
	<!---
	<div class="modal fade" id="filterModal">
	  <div class="modal-dialog" role="document" style="width: 300px !important">
		<div class="modal-content">
			<div class="modal-header">
				<h3 class="modal-title" id="filterModalTitle" style="text-align: center">Advanced Search</h3>
			</div>
		  <div class="modal-body">

			<form action="driverutil.cfm" method="put" name="advancedFilterForm" id="advancedFilterForm">


				<div class="form-group form-inline">
					<div class="typeahead__container formType">
						<div class="typeahead__field">
							<div class="typeahead__query">
								<label for="customerInput" style="text-align: right;width: 75px">Customer: </label>
								<input id="customerInput" name="customer" class="form-control" style="padding-right: 15px" autocomplete="off">
							</div>
						</div>
					</div>
				</div>
				
				<hr>
				
				<div class="form-group form-inline">
					<label for="groupbyInput">Group By: </label>
					<select id="groupbyInput" name="groupby" class="form-control">
						<option value="no-group">No Group</option>
						<option value="customer">Customer</option>
						<option value="plant">Plant</option>
					</select>
				</div>
				

			</form>

		  </div>
		  <div class="modal-footer">
            <button type="button" class="btn btn-primary" data-dismiss="modal">Apply</button>
          </div>
		</div>
	  </div>
	</div>
	--->
		
		
	<!--- END MODALS --->
	
	

	
</cfoutput>
	<script src="/includes/plugins/jquery_2.2.4/jquery-2.2.4.min.js"></script>
	<script src="/includes/plugins/bootstrap3/js/bootstrap.min.js"></script>
	<script src="/includes/plugins/basicTypeahead/jquery.typeahead.min.js"></script>
	<script src="/includes/plugins/datetimepicker/jquery.datetimepicker.full.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="/includes/plugins/webui-popover/dist/jquery.webui-popover.js" type="text/javascript"></script>
	<script src="/includes/plugins/DataTables_Old/datatables.min.js" type="text/javascript"></script>
	<script src="/includes/plugins/DataTables_Old/dataTables.buttons.min.js" type="text/javascript"></script>
	<script src="/includes/plugins/DataTables_Old/buttons.html5.min.js" type="text/javascript"></script>
	<script src="/includes/plugins/DataTables_Old/buttons.flash.min.js" type="text/javascript"></script>


<!--- Highcharts --->
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/series-label.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/export-data.js"></script>
<!---<script src="/WebServices/all_includes/Highcharts-6/code/modules/series-label.js"></script>--->
<!---<script src="/WebServices/all_includes/Highcharts-6/code/modules/exporting.js"></script>--->
<!---<script src="/WebServices/all_includes/Highcharts-6/code/modules/export-data.js"></script>--->
<!---
	<script src="https://code.highcharts.com/highcharts.src.js"></script>
	<script src="https://code.highcharts.com/highcharts.src.js"></script>
--->




	
<script type="text/javascript">
	
	
	// Don't cover nav with intropanel
	$('#introPanel').css("top",$('.navbar-fixed-top').outerHeight() + "px");
	
	
	$(document).ready(function(){

		// Intro
		setTimeout(function(){
			$('#reportTitleDiv > div').fadeOut();

			setTimeout(function(){
				$('#reportTitleDiv').css({"z-index":"9999","position":"absolute"});
				$('#reportTitleDiv').css({"transform":"translate(0, 0)"});
				$('#reportTitleDiv').css({"margin-left":"-40px","margin-top":"-46px","left":"inherit","top":" "});
				$('#reportTitle').css({"transform":"scale(0.5)"});
				setTimeout(function (){
					$('#introPanel').css({"animation":"fadeBG ease 1s"});
					$('#reportTitle').css({"color":"#fff","text-indent":"100px"});
					setTimeout(function (){
						$('#titleIcon').show();
					},200);
					setTimeout(function (){
						$('#introPanel').css({"background-color":"rgba(0,0,0,0)","z-index":"0","display":"none"});
						$('#refreshNote').fadeIn(800);
					},900);
				},150); //fade speed
			},1000);

		},850);
		
		
		
		
		// Init datepickers
		$("#dateStartInput").datetimepicker({
			timepicker:false,
			format:'m/d/Y'
		});	
		$("#dateEndInput").datetimepicker({
			timepicker:false,
			format:'m/d/Y'
		});	
		
		
		
		// Fix datatables column alignment on tab change
		$('a[data-toggle="tab"]').on('show.bs.tab', function (e) {
			  setTimeout(function ()
			  {
				thisTable.columns.adjust().draw();
			  }, 0 );
		});
		
		
		
		
		//DROPDOWNS
		// Select Report
		$('#reportMenu a').on('click', function(){
			var location = $(this).data("location");
			if (location !== undefined) {
				var thisUrlString = '/coldfusion/DriverUtilizationReport/' + location + '.cfm';
				window.location = thisUrlString;
			}
		});

		
		//  Select Chart
		var CHART_VARS = ["DrivTotalMSFChart","DrivNumberTripsChart","DrivStopsChart","DrivAvgMSFTripChart","DateAvgMSFDriver","DateAvgMSFTrip","DateAvgMilesDriver","DateAvgTripDriver"];
		//,"DrivMSFPerDayChart","DrivNumberTripsPerDayChart"
		
		var thisSelectedDiv;
		var lastSelectedDiv = "DrivTotalMSFDiv";
		$('.chartDiv').hide();
		$('.chartDiv.activeChart').show();
		
		$('#chartMenu a').on('click', function(){    
			thisSelectedDiv = $(this).data("showdiv");
			
			if(thisSelectedDiv != lastSelectedDiv){
				
				//swapping active class controls which chart is in view
				$('#' + lastSelectedDiv).removeClass('activeChart');
				
				//setTimeout to wait for css transition before applying to new chart 
				$('.chartDiv').fadeOut(600);
				$('#graphImg').fadeOut(600);
				setTimeout(function(){
					$('#' + thisSelectedDiv).addClass('activeChart');
					$('.chartDiv.activeChart').fadeIn(600);
					$('#graphImg').fadeIn(600);
					//Fire window resize at the end to fix chart full-width rendering bug,
					//probably caused by charts being drawn while display: none
					window.dispatchEvent(new Event('resize'));
				},601);
				
				
				//update dropdown with current selection
				$('.dropdown-toggle > #selectedChart').html($(this).html());
				
				//set last container
				lastSelectedDiv = thisSelectedDiv;
				
				
			}
			
		});
		
		$('#reportTitle').on('click',function(){
			$(this).addClass('clicked');
		});
		
		$('#reportTitleDiv').on('hide.bs.dropdown', function () {
		  $('#reportTitle').removeClass('clicked');
			$('#titleIcon').css("transform","rotate(0deg)");
			setTimeout(function(){
				$('#titleIcon').removeClass('fas fa-chevron-down').addClass('fas fa-truck');
			},75);
		});
		
		
		//Report Title Hover Swap Icon
		$('.hoverspinner').mouseenter(function(){
			if($('#reportTitle').hasClass('clicked') == false){
				$('#titleIcon').css("transform","rotate(-360deg)");
				setTimeout(function(){
					$('#titleIcon').removeClass('fas fa-truck').addClass('fas fa-chevron-down');
				},75);
			}
		}).mouseleave(function(){
			if($('#reportTitle').hasClass('clicked') == false){
				$('#titleIcon').css("transform","rotate(0deg)");
				setTimeout(function(){
					$('#titleIcon').removeClass('fas fa-chevron-down').addClass('fas fa-truck');
				},75);
			}
		});
		
		
		
		
		//sortSelect
		$('#sortMenu a').on('click', function(){    
			
			//update dropdown with current selection
			$('.dropdown-toggle > #selectedSort').html($(this).html());

		});
		
		


		
		// filter
//		var currentMargin = parseInt($('.searchButtonGroup').css("margin-left").slice(0,-2));
//		$('#addFilter').on('click', function(){
//			if($('#searchFilterOneContainer').is(":hidden")){
//				$('#searchFilterOneContainer').fadeIn("fast").css("display","inline");
//				
//				currentMargin += 185;
//				$('.searchButtonGroup').css("margin-left", currentMargin + "px");
//				
//				$('#searchFilterOneRemove').on('click',function(){
//					$(this).parent().parent().fadeOut("fast");
//					
//					$('#searchFilterOne').val('');
//					$('#searchFilterSelectOne').val('OrderNo').change();
//					
//					setTimeout(function(){
//						currentMargin -= 185;
//						$('.searchButtonGroup').css("margin-left", currentMargin + "px");
//					},300);
//					
//					$("#searchFilterOneRemove").off('click');
//				});
//				
//				
//			} else if($('#searchFilterTwoContainer').is(":hidden")){
//				
//				$("#searchFilterOneRemove").off('click');
//				
//				$('#searchFilterTwoContainer').fadeIn("fast").css("display","inline");
//				
//				currentMargin += 185;
//				$('.searchButtonGroup').css("margin-left", currentMargin + "px");
//				
//				//both filters present, hide button
//				$(this).parent().hide();
//				
//				
//				$('#searchFilterOneRemove').on('click',function(){
//					$(this).parent().parent().fadeOut("fast");
//					
//					$('#searchFilterOne').val('');
//					$('#searchFilterSelectOne').val('OrderNo').change();
//					
//					setTimeout(function(){
//						currentMargin -= 185;
//						$('.searchButtonGroup').css("margin-left", currentMargin + "px");
//					},300);
//					
//					if($('#addFilterDiv').is(':hidden')){
//						$('#addFilterDiv').show();
//					}
//					
//					$("#searchFilterOneRemove").off('click');
//				});
//				
//				$('#searchFilterTwoRemove').on('click',function(){
//					$(this).parent().parent().fadeOut("fast");
//					
//					$('#searchFilterTwo').val('');
//					$('#searchFilterSelectTwo').val('OrderNo').change();
//					
//					setTimeout(function(){
//						currentMargin -= 185;
//						$('.searchButtonGroup').css("margin-left", currentMargin + "px");
//					},300);
//					
//					if($('#addFilterDiv').is(':hidden')){
//						$('#addFilterDiv').show();
//					}
//					
//					$("#searchFilterTwoRemove").off('click');
//				});
//			}
//			
//		});



		

		var thisTable;
		var CHARTS = [];
		var tableDisplayed = 0;

		//Submit Form
		
		$('#reportFilterForm').submit(function(e){
			e.preventDefault();
			
			// Wrap search in timeout to allow instant 
			// search of first typeahead result on enter.
			var doSearch = setTimeout(function(){

				// Get Form Inputs
				var inputs = $('#reportFilterForm :input');
				//var advInputs = $('#advancedFilterForm :input');
				// Convert to Object
				var values = {};
				var advValues = {};
				
				inputs.each(function() {
					values[this.name] = $(this).val();
				});
	

				//Determine Search Method
				
				//input vars
				var plant;
				var driver;
				var startDate;
				var endDate;
				
				//adv input vars
				var emailCSV = 0;
				

				if (values.plant != "") {

					$('#resultTable').hide();
					plant = values.plant;
					driver = values.driver;

					if (values.startDate.trim() != "" && values.endDate.trim() != ""){

						//assign input values
						startDate = values.startDate.trim();
						endDate = values.endDate.trim();
						
						if ($("#emailCSV").prop("checked")){
							emailCSV = 1;
						}
						

						$('#nav').hide();
						$('#reportTabs').hide();
						$('#resultTableDiv').hide();
						$('.genCSVButton').hide();
						$('.tableFootnote').hide();
						$('tbody > tr').off('click');
					
						tableDisplayed = 0;

						//warehouse = values.warehouse.trim();
						$('#loaderText').html('Getting data');
						$('.loaderDiv').fadeIn();


						//perform the search
						$.ajax({
							type: "get",
							url: "driverutil_CFC.cfc?method=doSearch",
							dataType: "text",
							data: {
								plant: plant,
								driver: driver,
								startDate: startDate,
								endDate: endDate,
								emailCSV: 0
							},
							cache: false,
							success: function( data ){
								var json = data.trim();
								//alert(json);
// DOWNLOAD long JSON strings!!
//								var link = document.createElement('a');
//								link.setAttribute('href', 'data:text/plain,' + json);
//								link.setAttribute('download', 'json.txt');
//								link.click();
								
								obj = JSON.parse(json);
								if (obj.result == 'pass') {

									$('#loaderText').html('Generating report');
									$('#checkFilters').collapse('hide');
									
									// TABLE

									if(typeof thisTable !== 'undefined'){
										thisTable.destroy();
										$('#resultTable').empty();
									}

									var thePlant;
									var theDriver;
									var startDate;
									var endDate;
									
									var total_trips;
									var total_shipped_msf;

									//store data
									thePlant = obj.plant;
									startDate = obj.start_date;
									endDate = obj.end_date;
									
									total_trips = obj.total_trips;
									total_shipped_msf = obj.total_shipped_msf;


									$('#resultTableDiv').empty();
									$('#resultTableDiv').html('<table id="resultTable" class="tableStyle" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="display: none"><thead></thead><tbody></tbody><tfoot></tfoot></table>');
						
									
									//alert(obj.tableString);
									
									
									$('#resultTable > thead').html('<tr><th style="border-top-left-radius: 5px"><div align="right" class="noselect">Delivery Date</div></th><th><div align="right" class="noselect">Plant</div></th><th><div align="right" class="noselect">Driver</div></th><th ><div align="right" class="noselect">Trailer</div></th><th><div align="center" class="noselect">TripNo</div></th><th style="border-top-right-radius: 5px"><div align="left" class="noselect">MSF C-Flute Equivalent</div></th></tr>');
									
									$('#resultTable > tfoot').html('<tr><th></th><th></th><th></th><th></th><th id="uitems"><div align="center">' + total_trips + '</div></th><th id="total"><div align="left">' + total_shipped_msf + '</div></th></tr>');
									
									var exportTitle = 'DriverUtil_' + startDate + '__' + endDate;




									//append rowset to table
									$('#resultTable > tbody').append(obj.tableString);


									
									var table_order = 0;
									
//									if(group_by == 'customer'){
//										table_order = 1;
//									}
									
									
									//initiate datatable
									thisTable = $('#resultTable').DataTable({
										//"scrollY": '55vh',
										//"paging": false,
										"sScrollY":  ( $(window).height() - 455 ),
										"bPaginate": false,
										"bJQueryUI": true,
										"bScrollCollapse": true,
										"bAutoWidth": true,
										"sScrollX": "100%",
										"sScrollXInner": "100%",
										"orderClasses": true,
										"order": [[ table_order, "asc" ]],
										"dom": 'Bfrtip',
										"buttons": [{
												extend: 'csv',
												text: 'csv',
												extension: '.csv',
												footer: true,
												exportOptions: {
													modifier: {
														page: 'current'
													}
												},
												title: exportTitle
											}]
									});

									//redraw table to fix column alignment bug
									 setTimeout(function ()
									  {
										thisTable.columns.adjust().draw();
									  }, 10 );

									//make datatables search box bootstrap-y
									$('#resultTable_filter > label > input').addClass("form-control");
									
									
									//stylize main column
									var currFontSize = $(".mainCol").css('font-size');
									currFontSize = Number(currFontSize.substring(0, currFontSize.length - 2));
									var newFontSize = currFontSize + ((currFontSize) / 5);
									
									$(".mainCol").css('font-size', newFontSize + 'px');
									$(".mainCol").css("font-weight","bold");
									
									
									
									//CHART
									
									var CHART_TYPES = ['DrivTotalMSF','DrivNumberTrips','DrivStops','DrivAvgMSFTrip','DateAvgMSFDriver','DateAvgMSFTrip','DateAvgMilesDriver','DateAvgTripDriver'];
									//,'DrivMSFPerDay','DrivNumberTripsPerDay'
									
									if(CHARTS.length != 0){
										for(var i = 0; i < CHARTS.length; i++){
											CHARTS[i].destroy();
										}
									}
									
									
									var thisChartType;
									var thisChartDiv;
									var thisGoal;
									var goalLine;
									var rightMargin;
									
									//revert sort dropdown to default (A-Z)
									$('.dropdown-toggle > #selectedSort').html("A-Z");
									
									//loop to get data and create charts
									for(var i = 0; i < CHART_TYPES.length; i++){
	
										
										thisChartType = CHART_TYPES[i];
										thisChartDiv = CHART_TYPES[i] + 'Div';
										
										 
    									 //if (thisChartType) chart.destroy();
										
										var thisNumFormat = 0;
										if(thisChartType.search("AvgTripDriver") != -1){
											thisNumFormat = 1;
										}
										
										
										
										if(thisChartType.search("AvgMSFTrip") != -1){
											
											thisGoal = 110
											rightMargin = 40;
											
											goalLine = '[{"color": "#E9B481","width": 2,"value": ' + thisGoal + ',"label": {"text": "GOAL","align":"right","style": {"color": "#E9B481"},"y": 3,"x": 38}}]';
											
											goalLine = JSON.parse(goalLine);
											
										} else {
											goalLine = null;
											rightMargin = 0;
										}
										
									
									
										$.ajax({
											type: "get",
											url: "driverutil_CFC.cfc?method=getChartData",
											dataType: "text",
											async: false, //<--Important! Force JS to wait for Ajax response before moving forward
											data: {
												plant: plant,
												startDate: startDate,
												endDate: endDate,
												chartType: thisChartType
											},
											cache: false,
											success: function( data ){
												var json = data.trim();
												//alert(json);
				 //DOWNLOAD long JSON strings!!
//												var link = document.createElement('a');
//												link.setAttribute('href', 'data:text/plain,' + json);
//												link.setAttribute('download', 'json.txt');
//												link.click();

												obj2 = JSON.parse(json);
												if (obj2.result == 'pass') {

													var x_arr;
													var data_obj;
													var chart_plant;
													var chart_name;

													x_arr = obj2.x_arr;
													data_obj = obj2.data_obj;
													chart_plant = obj2.this_plant;
													chart_name = obj2.chart_name;

													if(chart_plant == 'ALL'){
														chart_plant = 'All Plants'
													}
													
													//column or line graph
													var graphType = 'column';
													if(thisChartType === 'DateAvgMSFDriver' || thisChartType === 'DateAvgMSFTrip' || thisChartType === 'DateAvgMilesDriver' || thisChartType === 'DateAvgTripDriver'){
														graphType = 'line';
													}

													
													//creating many charts with same variable name...Bad practice because only the final chart in the loop will be referencable
													
													thisChartType = Highcharts.chart(thisChartDiv, 
													{

														chart: {
															scrollablePlotArea: {

															},
															marginRight: 40,
															type: graphType,
															events: {
															  load: function() {
																var points = this.series[0].points,
																  chart = this,
																  newPoints = [];

																Highcharts.each(points, function(point, i) {
																  point.update({
																	name: x_arr[i]
																  }, false);
																  newPoints.push({
																	x: point.x,
																	y: point.y,
																	name: point.name
																  });
																});
																chart.reflow();

																// Sorting A - Z
																$('#sortAZ').on('click', function() {
																  newPoints.sort(function(a, b) {
																	if (a.name < b.name)
																	  return -1;
																	if (a.name > b.name)
																	  return 1;
																	return 0;
																  });

																  Highcharts.each(newPoints, function(el, i) {
																	el.x = i;
																  });

																  chart.series[0].setData(newPoints, true, false, false);
																});

																// Sorting min - max
																$('#sortMinMax').on('click', function() {
																  newPoints.sort(function(a, b) {
																	return a.y - b.y
																  });

																  Highcharts.each(newPoints, function(el, i) {
																	el.x = i;
																  });

																  chart.series[0].setData(newPoints, true, false, false);
																});

																// Sorting max - min
																$('#sortMaxMin').on('click', function() {
																  newPoints.sort(function(a, b) {
																	return b.y - a.y
																  });

																  Highcharts.each(newPoints, function(el, i) {
																	el.x = i;
																  });

																  chart.series[0].setData(newPoints, true, false, false);
																});
															  }
															}
														},

														title: {
															text: chart_name
														},

														subtitle: {
															text: chart_plant
														},

														xAxis: {
															categories: x_arr
														},

														yAxis: [{
															title: {
																text: ''
															},
															showFirstLabel: false,
															plotLines: goalLine
														}],

														legend: {
															align: 'left',
															verticalAlign: 'top',
															borderWidth: 0
														},

														tooltip: {
															shared: true,
															crosshairs: false,
															formatter: function() {
															   var s = '<strong>' + this.x +'</strong>';

															   var sortedPoints = this.points.sort(function(a, b){
																	 return ((a.y > b.y) ? -1 : ((a.y < b.y) ? 1 : 0));
																 });
															   $.each(sortedPoints , function(i, point) {
															   s += '<br/>' + '<span style="color:' + point.series.color + '">\u25CF</span> ' + point.series.name +': ' + point.y.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
															   });

															   return s;
															}
														},

														plotOptions: {
															series: {
																cursor: 'pointer',
																lineWidth: 2,
																marker: {
																	lineWidth: 0.5,
																	radius: 4.5
																}
															},
															column: {
																dataLabels: {
																	enabled: true,
																	crop: false,
																	overflow: 'none',
																	formatter: function () {
																		return Highcharts.numberFormat(this.y,thisNumFormat);
																	}
																}
															}
														},
														exporting: { enabled: true },

														series: data_obj
												});
													
												//CHARTS.push(chart);
											

											} else {

												alert(obj.reason);
												$('.loaderDiv').fadeOut();

												return false;
											} 				
										}
									});
										
										
								} //Loop CHART_TYPES
									
									
									
									
	

									

									//Everything is ready, show user
									$('.loaderDiv').hide();

									$('#resultTable_wrapper > .dt-buttons > .dt-button > span').html('Download Table');
									$('#actionButtons').fadeIn();
									$('#reportTabs').fadeIn();
									$('#resultTableDiv').fadeIn();
									tableDisplayed = 1;		
									//fade in class, otherwise datatables hides header
									$('.tableStyle').fadeIn();
									//$('.tableFootnote').fadeIn();
									//$('.genCSVButton').fadeIn();
									




								} else {

									alert(obj.reason);
									$('.loaderDiv').fadeOut();

									return false;
								} 				
							}
						});






					} else {
						alert('You must select a date range.');
					}

				} else {
					alert('Please select a plant.');
				}


			},100);

		});
	

	}); //ready
	
	


	
	
	function toggleBG(e){
		if($(e).css("background-color") == '#ffffff'){
			$(e).css("background-color","rgba(31,58,142,0.05) !important");
		} else {
			$(e).css("background-color","#ffffff");
		}
	}
	
	
//	function notify(message, status) {
//		theMessage = message;
//		theStatus = status;
//		
//
//		
//		$('#notifyMessage').html(theMessage);
//		
//		switch(theStatus){
//				
//			case 'loading':
//				$('#notifyBox').css("background-color","#DDF5FF");
//				$('#notifyMessage').before('<i class="fas fa-spinner notifyIcon" id="notifySpinner"></i>');
//				break;
//						
//			case 'success':
//				$('#notifyBox').css({"background":"-webkit-linear-gradient(45deg, #61c419 0%,#b4e391 100%)","background":"linear-gradient(45deg, #61c419 0%,#b4e391 100%)"});
//				$('#notifyMessage').before('<i class="fas fa-exclamation-circle notifyIcon" id="notifySuccess"></i>');
//				break;	
//				
//			case 'failure':
//				$('#notifyBox').css("background-color","#FF7A7C");
//				$('#notifyMessage').before('<i class="fas fa-exclamation-triangle notifyIcon" id="notifyFailure"></i>');
//				break;
//				
//						
//		}
//		
//		$('#notifyBox').css("transform","translateX(0px)");
//		
//		setTimeout(function(){
//			$('#notifyBox').css("transform","translateX(250px)");
//			$('.notifyIcon').remove();
//			return 'success';
//		},4000);
//			
//	
//	}
		
	
</script>
</body>
</html>
	
	
<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>
