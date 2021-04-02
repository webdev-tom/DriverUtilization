<cfparam name="startDate" default="#DateFormat(DateAdd('d',-1,now()), 'mm/dd/yyyy')#">
<cfparam name="endDate" default="#DateFormat(now(),'mm/dd/yyyy')#">
	
	
<cftry>	
	
<!--- If Monday start search last Friday --->
<cfif DayOfWeek(endDate) eq 2>
	<cfset startDate = DateFormat(DateAdd("d",-3,now()),"mm/dd/yyyy")>
</cfif>
	
<cfquery name="getCompany" datasource="Corporate">
	SELECT DISTINCT
		Company,
		Company_id
	FROM 
		CompanyList
	WHERE
		Company NOT IN ('LouisvilleKY','Columbia')
	ORDER BY 
		Company_id ASC;
</cfquery>
	
<cfquery name="getDrivers" datasource="Corporate">
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
<title>Warehouse Transfer Report Demo | tomfafard.com</title>
	
	
<style>
	
	body{
		background-color: #fefefe;
	}
	
	th {
		transition: 0.3s ease;
	}
	
	th:hover {
		background-color: #efefef;
	}
	
	tbody > tr:hover{
		background-color: rgba(31,58,142,0.05) !important;
	}
	
	
	tfoot tr th {
		white-space: nowrap;
	}
	
	table.dataTable tfoot th, table.dataTable tfoot td{
		padding: 5px 18px 6px 18px !important;
	}
	
	li.active{
		font-weight: bold;
		text-shadow: none !important;
	}
	
/* TEXT SHADOW HOVER TAB
	.nav-tabs.nav-justified > li > a:hover #tabhdr1{
		color: #fff;
    	text-shadow: 0 0 10px #666,                
					 0 0 10px #666,                
					 0 0 10px #666,                
					 0 0 10px #666,                
					 0 0 10px #666,                
					 0 0 5px #000,                
					 0 0 5px #000,                
					 0 0 5px #000,               
					 0 0 5px #000,                
					 0 0 5px #000;
	}
	
	.nav-tabs.nav-justified > li > a:hover #tabhdr2{
		color: #eee;
    	text-shadow: 0 0 12px #337ab7,                
					 0 0 12px #337ab7,                
					 0 0 12px #337ab7,                
					 0 0 12px #337ab7,                
					 0 0 12px #337ab7,                
					 0 0 6px #23527c,                
					 0 0 6px #23527c,                
					 0 0 6px #23527c,               
					 0 0 6px #23527c,                
					 0 0 6px #23527c;
	}
	
	.tabtitle{
		-webkit-transition: 0.5s all ease;
		-moz-transition: 0.5s all ease;
		-o-transition: 0.5s all ease;
		transition: 0.5s all ease;
		
		Safari Fix
		-webkit-transform: translateZ(0);
		display: inline-block;
	}
	
*/
	
	
	
	
	
	/* TABLE STYLE */
	
/*
	table.tableStyle {
	font-family: "lucida grande", verdana, sans-serif;
	margin:0px;
	font-size:14px;
	width: 100%;
	text-align: center;
	}
*/
 
/*
	table.tableStyle td, table.tableStyle th { 
		border-bottom:1px solid #ccc;
		font-size:0.875em;
		padding: 4px;
	} 
*/

/*
	table.tableStyle th { 
		font-size:0.875em;
		font-weight: 600; 
		color: #FFF; 
	} 
*/

/*
	table.tableStyle  a:link {	
		line-height:1.3em; 
		text-decoration:none;
		color:black; 
		display:inline-block; 
		padding:3px 7px; margin:-3px -7px;
	}
	table.tableStyle a:visited	{	
		color:#003399; 
	}
	table.tableStyle a:hover {	
		text-decoration:none; background:#3d80df; 
		color:white; 
		-webkit-border-radius:4px; 
		-moz-border-radius:4px; 
		border-radius:4px;
	}
*/
	
	
	/*CUSTOM CHECKBOX*/
	
	/* Base for label styling */
	[type="checkbox"]:not(:checked),
	[type="checkbox"]:checked {
	  position: absolute;
	  left: -9999px;
	}
	[type="checkbox"]:not(:checked) + label,
	[type="checkbox"]:checked + label {
	  position: relative;
	  padding-left: 1.95em;
	  cursor: pointer;
	}

	/* checkbox aspect */
	[type="checkbox"]:not(:checked) + label:before,
	[type="checkbox"]:checked + label:before {
	  content: '';
	  position: absolute;
	  left: 0; top: 0;
	  width: 1.25em; height: 1.25em;
	  border: 2px solid #ccc;
	  background: #ededed;
	  border-radius: 4px;
	  box-shadow: inset 0 1px 3px rgba(0,0,0,.1);
	}
	/* checked mark aspect */
	[type="checkbox"]:not(:checked) + label:after,
	[type="checkbox"]:checked + label:after {
	  content: '\2713';
	  position: absolute;
	  top: .14em;
	  left: .1em;
	  font-size: 1.4em;
	  line-height: 0.8;
	  color: #275DA4;
	  transition: all .2s;
	  font-family: Helvetica, Arial, sans-serif;
	}
	/* checked mark aspect changes */
	[type="checkbox"]:not(:checked) + label:after {
	  opacity: 0;
	  transform: scale(0);
	}
	[type="checkbox"]:checked + label:after {
	  opacity: 1;
	  transform: scale(1);
	}
	/* disabled checkbox */
	[type="checkbox"]:disabled:not(:checked) + label:before,
	[type="checkbox"]:disabled:checked + label:before {
	  box-shadow: none;
	  border-color: #bbb;
	  background-color: #ddd;
	}
	[type="checkbox"]:disabled:checked + label:after {
	  color: #999;
	}
	[type="checkbox"]:disabled + label {
	  color: #aaa;
	}
	/* accessibility */
	[type="checkbox"]:checked:focus + label:before,
	[type="checkbox"]:not(:checked):focus + label:before {
	  border: 2px dotted blue;
	}

	/* hover style just for information */
	label:hover:before {
	  border: 2px solid #4778d9!important;
	}
	
	.dataTables_info{
		padding-top: 0px !important;
		position: absolute !important;
		bottom: 0 !important;
	}
	
	.typeahead__container{
		font-size: 14px !important;
	}
	
	.typeahead__field{
		color: #333333 !important;
	}
	
	.typeahead__field input{
		border-radius: 4px !important;
	}

	.formType .typeahead__result .typeahead__list{
		width: auto !important;
		left: 80px !important;
	}
	
	.formType .typeahead__field .typeahead__query .typeahead__cancel-button{
		visibility: hidden !important;
	}
	
	.sorting_1{
		background-color: rgba(234,234,234,0.5);
	}
	
	.noselect {
 		-webkit-touch-callout: none; /* iOS Safari */
    	-webkit-user-select: none; /* Safari */
    	-khtml-user-select: none; /* Konqueror HTML */
       	-moz-user-select: none; /* Firefox */
        -ms-user-select: none; /* Internet Explorer/Edge */
            user-select: none; /* Non-prefixed version, currently
                                  supported by Chrome and Opera */
		cursor: default;
	}
	
	.navbar{
		border-radius: 0 !important;
		background-color: #143D90 !important;
		border-color: #080808 !important;
	}
	
	.easyTransition {
		-webkit-transition: all 100ms linear;
		-moz-transition: all 100ms linear;
		transition: all 100ms linear;
	}
	
	.selectStyle {
		display: inline-block !important;
		width: 40% !important;
	}
	
	.inputStyle {
		display: inline-block;
	}
	
	.upperHeaderDiv {
		font-weight: bold; 
		color: #fff; 
		background-color: #1B5FA6;
		font-size: 13px;
	}
	
	.rangeStyle{
		position: absolute;
		padding-left: 12px;
		padding-top: 5px
	}
	
	.tableFootnote {
		float: right;
		padding-right: 10px;
		color: rgba(0,0,0,0.4);
		font-style: italic;
		cursor: default;
		user-select: none;
		-webkit-user-select: none;
	}
	
	.loader {
		width: 150px;
		text-align: center;
		font-size: 6em;
		color: rgba(39, 93, 164, 0.6);
		animation: spin 1s linear infinite;
	}
	
	.loader > img {
		width: inherit;
	}
	
	.filterInfo{
		cursor: help;
	}
	
	.modal-dialog{
		width: 90% !important;
	}
	
	.modal-body {
    	max-height: calc(100vh - 100px);
		overflow-y: scroll;
	}
	
	.genCSVButton{
		float: right;
		height: 20px !important;
		line-height: 0.3 !important;
		font-size: 13px !important;
		transition: 0.2s ease-in-out !important;
	}
	
	.genCSVButton:hover{
		-webkit-box-shadow: 0 0 8px limegreen;
		-moz-box-shadow: 0 0 8px limegreen;
		box-shadow: 0 0 8px limegreen;
	}
	
	.upperTableGroup{
		transition: 0.3s linear;
		margin-bottom: 3px;
	}
	
	.notifyIcon{
		position: absolute;
		top: 17px;
		left: 10px;
		font-size: 20px;
	}
	
	.itemButtonDiv{
		border-radius: 20px;
		float: left;
		padding-left: 15px;
		padding-right: 15px;
		transition: ease 0.3s;
	}
	
	.itemButtonDiv:hover, .itemButtonDiv.hovered {
		-webkit-box-shadow: 0 0 20px rgba(0,0,0,0.8);
		-moz-box-shadow: 0 0 20px rgba(0,0,0,0.8);
		box-shadow: 0 0 6px rgba(0,0,0,0.6);
		background-color: #4ABDAC;
		color: #FEFEFE;
	}
	
	
	.itemButtonDiv:hover a span{
		color: rgba(255,255,255,0.7) !important;
	}
	
	.ticketButtonDiv{
		border-radius: 20px;
		padding-left: 15px;
		padding-right: 15px;
		padding-top: 5px;
		padding-bottom: 5px;
		transition: ease 0.3s;
		display: inline-block;
	}
	
	.ticketButtonDiv:hover, .ticketButtonDiv.hovered {
		-webkit-box-shadow: 0 0 20px rgba(0,0,0,0.8);
		-moz-box-shadow: 0 0 20px rgba(0,0,0,0.8);
		box-shadow: 0 0 6px rgba(0,0,0,0.6);
		background-color: #E74339;
		color: #FEFEFE;
	}
	
	
	.modalTrigger{
		float: left;
		text-decoration: none !important;
	}
	
	.timeline__item:hover:after{
		background-color: #3F576C;
	}
	
	.timeline__content > p {
		font-size: 14px !important;
	}
	
	.timeline__content > h2 {
		font-size: 13px !important;
	}
	
	.dt-buttons{
		text-align: right !important;
		margin-bottom: 5px !important;
	}
	
	.dt-button{
		color: #fff;
		background-color: #5cb85c;
		border-color: #4cae4c;
		border: 0;
		border-radius: 5px;
		transition: 0.2s ease-in-out !important;
	}
	
	.dt-button:hover{
		-webkit-box-shadow: 0 0 8px limegreen;
		-moz-box-shadow: 0 0 8px limegreen;
		box-shadow: 0 0 8px limegreen;
	}
	
	.selectedRow {
		background-color: #A0C6E8 !important;
	}
	
	.selectedRow:hover {
		background-color: #A0C6E8 !important;
	}
	
	.thisBucketClicked {
		transform: scale(1.1) !important;
		color: #fff !important;
	}
	
	.carousel-control.left{
		filter: none;
		background-image: none !important;
		background-repeat: no-repeat !important;
		color: #3679B5 !important;
		text-shadow: 0 1px 2px !important;
	}
	
	.carousel-control.right{
		filter: none;
		background-image: none !important;
		background-repeat: no-repeat !important;
		color: #3679B5 !important;
		text-shadow: 0 1px 2px !important;
	}
	
	.carousel-control .icon-next{
		line-height: 22px !important;
		border-radius: 30px;
		border: 1px solid #444;
		box-shadow: 0 0 1px 0px #444 inset, 0 0 1px 0px #444 !important;
		background-color: #fff;
	}
	
	.carousel-control .icon-prev{
		line-height: 22px !important;
		border-radius: 30px;
		border: 1px solid #444;
		box-shadow: 0 0 1px 0px #444 inset, 0 0 1px 0px #444 !important;
		background-color: #fff;
	}
	
	.carousel-control .icon-next:before{
		padding-left: 3px !important;
	}
	
	.highcharts-data-table{
		border-bottom: 1px solid #ddd !important;
	}
	
	.highcharts-data-table > table{
		width: 50%;
		margin: 0 auto !important;
		text-align: center !important;
	}
	
	.highcharts-data-table > table > caption{
		text-align: center !important;
	}
	
	.highcharts-data-table > table > thead > tr > th{
		text-align: center !important;
	}
	
	.highcharts-data-table > table > tbody > tr > th{
		text-align: center !important;
	}
	
	.searchFilterInput {
		width: 181px !important;
		height: 34px !important;
	}
	
	.searchFilterSelect {
		margin-top: 2px;
		width: 139px !important;
		height: 34px !important;
	}
	
	.searchFilterStyle{
		display: inline;
		margin-right: 4px;
	}
	
	
	.filterHeader{
		position: absolute;
		top: -39px;
	}
	
	.searchButtonGroup{
		display: inline-flex !important;
		position: absolute;
		margin-left: 4px;
	}
	
	.form-group > label{
		width: 75px;
		text-align: right;
	}
	
	.mainCol{
		white-space: nowrap;
	}
	
	.bBorder{
		border-bottom: 1px solid #ededed;
	}
	
	.nav-tabs > li {
		float:none;
		display:inline-block;
		zoom:1;
	}

	.nav-tabs {
   	 text-align:center;
	}
	
	.chartDiv{
		height: calc(100vh - 321px);
	}
	
	.tab-pane{
		padding: 10px 20px 30px 20px;
		border-left: 1px solid #ddd;
		border-right: 1px solid #ddd;
		border-bottom: 1px solid #ddd;
		border-bottom-right-radius: 5px !important;
		border-bottom-left-radius: 5px !important;
		box-shadow: 0 8px 17px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
		-moz-box-shadow: 0 8px 17px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
		-webkit-box-shadow: 0 8px 17px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
	}
	

	
	
	#itemTixTable_wrapper .dt-buttons{
		position: absolute;
		z-index: 200 !important;
		right: 0px;
		top: -23px;
	}
	
	#itemTixTable_wrapper .dt-buttons > .dt-button{
		color: #000;
		background-color: rgba(255,255,255,0);
		border: 0;
		border-radius: 5px;
		transition: 0.2s ease-in-out !important;
	}
	
	#itemTixTable_wrapper .dt-buttons > .dt-button:hover{
		-webkit-box-shadow: none;
		-moz-box-shadow: none;
		box-shadow: none;
		color: #3679B5;
	}
	
	#itemTixTable_wrapper .dataTables_scroll .dataTables_scrollHead .dataTables_scrollHeadInner table thead {
		line-height: 5px !important;
		white-space: nowrap !important;
	}
	
	#itemTixTable_wrapper .dataTables_scroll .dataTables_scrollHead .dataTables_scrollHeadInner table thead tr {
		height: 5px !important;
	}
	
	#itemTixTable_wrapper{
		width: 70% !important;
		margin: 0 auto !important;
	}
	
	#itemTixTable > tbody > tr > td {
		padding: 0 !important;
	}
	
	#nav {
		user-select: none;
		-webkit-user-select: none;
		margin-bottom: 20px;
		display: block;
		float: none;
		position: relative;
		text-align: center;
	}
	
	#nav > div > a {
		width: 100%;
		height: 100%;
		text-decoration: inherit;
		color: inherit;
		cursor: inherit !important;
	}
	
	#nav > div {
		padding: 5px;
		border: 1px solid #ebebeb;
		margin: -2px;
		text-decoration: none !important;
		color: #275DA4;
		width: 40px;
		height: 100%;
		text-align: center;
		display: inline-block;
		cursor: pointer;
	}
	
	#nav > div:first-child {
		padding: 5px;
		border: 1px solid #ebebeb;
		border-top-left-radius: 8px;
		border-bottom-left-radius: 8px;
	}
	
	#nav > div:last-child {
		padding: 5px;
		border: 1px solid #ebebeb;
		border-top-right-radius: 8px;
		border-bottom-right-radius: 8px;
	}
	
	#nav > div:hover {
		background-color: #275DA4;
/*		box-shadow: 0 8px 6px -6px black;*/
		transition: ease 0.2s;
		color: #fff;
	}
	
	#brand-image {
		width: 190px;
		height: 45px;
		top: 2px;
		left: -2px;
		position: absolute;
	}
	
	#reportFilterFormDiv {
		margin: auto;
		width: 90%;
		transition: 1s ease;
	}
	
	
	#addFilterDiv{
		display: inline;
		margin-right: 3px;
	}
	
	#addFilter{
		background-color: rgba(255,255,255,0);
		border: 1px solid #C0C0C0;
	}
	
	#addFilter:hover{
		color: #fff;
		background-color: #C0C0C0;
	}
	
	#submitDiv {
		display: inline;
	}
	
	#submitBtn {
		margin-bottom: 3px !important;
		padding: 6px 12px !important;
		border-radius: 5px !important;
		background-color: #C0C0C0 !important;
	}
	
	#submitBtn:hover {
		background-color: #1B5FA6 !important;
		color: #FFF !important;
	}
	
	#plantSelect {
/*		width: 325px !important;*/
		display: block;
		height: 34px;
		padding: 6px 12px;
		font-size: 14px;
		line-height: 1.42857143;
		color: #555;
		background-color: #fff;
		background-image: none;
		border: 1px solid #ccc;
		border-radius: 4px;
		-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
		box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
		-webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
		-o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
		transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	}
	
	#customerRangeInput {
		width: 50px !important;
		height: 26px !important;
		text-align: center;
	}
	
	#vendorInput {
		width: 325px !important;
		display: block;
		height: 34px;
		padding: 6px 12px;
		font-size: 14px;
		line-height: 1.42857143;
		color: #555;
		background-color: #fff;
		background-image: none;
		border: 1px solid #ccc;
		border-radius: 4px;
		-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
		box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
		-webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
		-o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
		transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	}
	
	#vendorRangeInput {
		width: 50px !important;
		height: 26px !important;
		text-align: center;
	}
	
	#filterGradeInput {
		width: 90px !important;
		height: 22px !important;
		margin-left: 3px;
	}
	
	#rowThresholdInput{
		height: 30px !important;
		margin-left: 3px;
	}
	
	#displayFilterToggle {
		display: block;
		padding-left: 8px;
		color: black;
		margin-top: 2px;
		width: 140px;
		outline: none;
	}
	
	#displayFilterToggle:hover {
		text-decoration: none;
	}
	
	#displayFilterToggle > i {
		transition: linear 200ms;
	}
	
	#checkFilters {
		margin-top: 5px;
		padding-left: 8px;
	}
	
	#resultRow {
/*		margin-bottom: 50px;*/
		height: 20vh;
/*
		margin-right: -150px !important;
		margin-left: -150px !important;
*/
	}
	
	#resultTable_length{
		display: none;
	}
	
	#resultTable {
/*		margin-top: 30px;*/
/*		margin-bottom: 50px;*/
		table-layout:fixed;
		width: 98% !important; 
	}
	
	#resultTable > tbody > tr > td:first-child { 
		border-top-left-radius: 2px; 
		border-bottom-left-radius: 2px; 
	}
	
	#resultTable > tbody > tr > td:last-child { 
		border-top-right-radius: 2px;
		border-bottom-right-radius: 2px; 
	}
		

	
	#TableStyleContainer{
		display: inline-grid;
	}
	
	#resultDiv{
		height: 100%;
		transition: 1s ease;
	}
	

	
	#itemAnalysisDiv{
		transform: translateY(250px);
		transition: 1s ease;
	}
	
	#upperHeaderRow {
		height: 40px;
	}
	
	#headerRow {
		background-color: #5E90C4; 
		height: 20px; 
		color: #eee
	}
	
	#emailConfirm {
		background-color: #ACDAB5;
		font-size: 1.15em;
		width: 220px;
		color: rgba(255, 255, 255, 0.85);
		text-align: center;
		border-radius: 10px;
		position: absolute;
		right: 0px;
		top: 75px;
		padding: 3px;
		margin-right: 10%;
		box-shadow: 0 8px 6px -6px rgba(0,0,0,0.4);
	}
	
	#introPanel {	
		width: 100%;
		height: calc(100vh + 100px);
		top: -100px;
		position: absolute;
		background-color: #fefefe;
		z-index: 9999;
		text-align: center;
		top: 0;
		left: 0;
	}
	
	#reportTitleDiv {
		z-index: 9999;
		/*	text-align: center;*/
		/*	padding-top: 25vh;*/
		transition: ease 0.5s;
		position: absolute;
		top: 50%;
		left: 50%;
		margin-top: 150px;
		/*margin-left: 80px;*/
		width: 800px;
		transform: translate(-50%, 50%);
	}
	
	#reportTitle {
		font-size: 3.5em;
		text-align: center;
		display: block;
		transition: all 0.5s;
		font-family: Constantia, "Lucida Bright", "DejaVu Serif", Georgia, "serif";
		box-shadow: none !important;
		cursor: pointer;
	}
	
	#titleIcon{
		transition: transform 500ms ease;
		transform-origin: 65px center;
	}
	
	#reportMenu{
		left: 260px !important;
		top: 55px !important;
	}
	
	#reportMenu.clicked{
		display: block;
	}
	
	
	#reportDropdown > ul {
		text-indent: 0 !important;
		font-family: "Helvetica Neue", Helvetica, Arial, "sans-serif" !important;
		font-size: 1em !important;
	}
	
	#loader-label {
		font-size: 1.5em;
		color: rgba(0,0,0,0.6)
	}
	
	#moreButton{
		position: absolute;
		width: 75px;
		height: 75px;
		background-color: #FFF;
		bottom: -12px;
		left: 50%;
		border-radius: 50px;
		text-align: center;
		transition: ease 0.2s;
		cursor: pointer;
		border: 1px solid rgba(0,0,0,0.2);
	}
	
	#moreButton:hover{
		background-color: #1B5FA6 !important;
		color: #FFF !important;
		-webkit-box-shadow: 0 10px 6px -6px #777;
        -moz-box-shadow: 0 10px 6px -6px #777;
        box-shadow: 0 10px 6px -6px #777;
	}
	
	#moreButtonText{
		font-size: 40px;
		margin-top: 10%;
	}
	
	#moreButtonSpinner{
		font-size: 40px;
		margin-top: 1%;
		animation: spin 2s linear infinite;
	}
	
	#csvPrompt{
		transition: 0.3s linear;
		transform: translateX(-150px);
		opacity: 0;
		position: absolute;
		right: 15px;
		top: -9px;
		font-family: Verdana, "sans-serif";
	}
	
	#csvRowsInput{
		width: 55px;
		text-align: center;
	}
	
	#csvRowsSubmit{
		
	}
	
	#includeAmtechContainer{
		padding-left: 20px;
	}
	
	
	
	#notifyBox{
		position: fixed;
		width: 150px;
		height: 50px;
		color: #fff;
		right: 0;
		top: 85px;
		z-index: 9999;
		transition: ease 0.3s;
		transform: translateX(250px);
		border-top-left-radius: 5px;
		border-bottom-left-radius: 5px;
	}
	
	#notifySpinner{
		color: whitesmoke;
		animation: spin 1s linear infinite;
	}
	
	#notifySuccess{
		
	}
	
	#notifyFailure{
		
	}
	
	#orderInput {
	}
	
	#notifyMessage{
		position: absolute;
		top: 16px;
		left: 40px;
		font-size: 16px;
	}
	
	#refreshNote{
		position: absolute;
		right: 10px;
		top: 50px;
		color: rgba(211,211,211,0.6);
		font-style: italic;
	}
	
	#resultWarning{
		position: absolute;
		width: 345px;
		right: 50px;
		top: 90px;
		color: red;
		font-size: 12px;
	}
	
	#resultTable_filter > label > input{
		display: inline !important;
		width: initial !important;
	}
	

	#chartSelect{
		display: inline;
	}
	
	#graphImg{
		position: relative;
		float: right;
		margin-right: 10px;
	}
	
	#switchImg{
		position: absolute;
		right: 10px;
	}
	

	
	
	#wave{
		font-size: 1em;
		line-height: 0;
	}
	
	#ticketDetailPlant::after {
		content: "  |  ";
	}
	
	#ticketDetailItem::after { 
    	content: "  |  ";
	}
	
	#ticketDetailWeight::after {
		content: "  |  ";
	}
	
	#ticketDetailDR::before{
		content: "  |  ";
	}
	
	
	#costDetailToggle:hover .detail__dot {
	  display: inline-block;
	  animation: wave 0.6s linear;
	}
	#costDetailToggle:hover .detail__dot:nth-child(2) {
	  animation-delay: 125ms;
	}
	#costDetailToggle:hover .detail__dot:nth-child(3) {
	  animation-delay: 250ms;
	}
	
	
	@keyframes wave {
	  0%, 60%, 100% {
		transform: initial;
	  }
	  30% {
		transform: translateY(-4px);
	  }
	}


	@keyframes blink {50% { color: transparent }}
	.loader__dot { animation: 1s blink infinite }
	.loader__dot:nth-child(2) { animation-delay: 250ms }
	.loader__dot:nth-child(3) { animation-delay: 500ms }
	
	
	@keyframes spin {
		0% { transform: rotate(0deg); }
		100% { transform: rotate(360deg); }
	}
	
	@keyframes fadeBG {
	  0%   { background-color: #FFFFFF; }
	  100% { background-color: rgba(0,0,0,0); }
	}
	
	
</style>
<link href="/css/bootstrap/bootstrap_3_3_6/bootstrap.css" rel="stylesheet">
<link href="/WebServices/all_includes/basicTypeahead/jquery.typeahead.min.css" rel="stylesheet">
<link href="/css/fontawesome-550/css/all.min.css" rel="stylesheet">
<link href="/WebServices/all_includes/datetimepicker/jquery.datetimepicker.css" rel="stylesheet">
<link href="/WebServices/all_includes/webuipopover/jquery.webui-popover.css" rel="stylesheet">
<link href="/WebServices/all_includes/DataTables/datatables.min.css" rel="stylesheet">
<link href="/WebServices/all_includes/timelinejs/timeline.min.css" rel="stylesheet">
</head>
<body>
<cfoutput>
	
	<nav class="navbar navbar-default navbar-fixed-top">
	  <div class="container-fluid">
		<div class="navbar-header">
<!---		  <a class="navbar-brand" href="/Webservices/CCApps.cfm/#session.urltoken#">--->
			<img id="brand-image" alt="Brand" src="/all_images/CC/CCMenuBannerNoBurger.gif" draggable="false">
		  </a>
		</div>
	  </div>
		<div class="top-menu">
			<ul class="nav navbar-nav pull-right" style="margin-right: 560px">
				<li id="nav-right" style="position: static">
					<div id="introPanel"></div>
					<div id="reportTitleDiv" class="btn-group">
						<h1 id="reportTitle" class="noselect dropdown-toggle hoverspinner" data-toggle="dropdown">
							 <i id="titleIcon" class="fas fa-warehouse" style="display: none"></i> <span>Warehouse Transfer Report</span></h1>
						<ul id="reportMenu" class="dropdown-menu hoverspinner" role="menu">
							<li><a href="##" data-location="driverutil"><i class="fas fa-truck"></i> Driver Utilization</a></li>
							<li><a href="##" data-location="customerutil"><i class="fas fa-users"></i> Customer Utilization</a></li>
							<li><a href="##" data-location="whsxferutil"><i class="fas fa-warehouse"></i> Warehouse Xfer Report</a></li>
						</ul>
						<div class="loader" style="position: absolute;left: 40.5%"><img src="/all_images/CC/blue_loading.png"></div>
					</div>
				</li>
			</ul>
		</div>
	</nav>
	
	
	
<!---
	<div id="introPanel"></div>
	<div id="reportTitleDiv" class="pull-right">
		<h1 id="reportTitle" class="noselect"><i id="titleIcon" class="fas fa-list" style="display: none"></i> Purchased Item Margin Report</h1>
		<div class="loader" style="position: absolute;left: 35%"><i class="fas fa-spinner"></i></div>
	</div>
--->
	
	
	<div class="container" style="padding-top: 60px; width: auto !important;">
		<div id="inputRow" class="row">
			<div class="col-sm-12">
				
				<img src="/all_images/common/switchReport.gif" width="110px" id="switchImg">
				
<!---
				<div id="reportSelect">
					<div class="btn-group">
						<button type="button" class="form-control btn btn-default dropdown-toggle" data-toggle="dropdown">
							<span id="selectedReport">Driver Utilization</span> <span class="caret"></span>
						</button>
						<ul id="reportMenu" class="dropdown-menu" role="menu">
							<li><a href="##" data-location="driverutil">Driver Utilization</a></li>
							<li><a href="##" data-location="customerutil">Customer Utilization</a></li>
							<li><a href="##" data-location="whsxferutil">Warehouse Xfer Report</a></li>
						</ul>
					</div>
				</div>
--->
				<div id="emailConfirm" class="noselect" style="display: none"><i class="fas fa-exclamation-circle"></i> CSV sent to your inbox</div>
				<div id="reportFilterFormDiv" class="form-group">
					<form action="whsxferutil.cfm" method="put" name="reportFilterForm" id="reportFilterForm">
						
						<h4 id="searchHeader" class="noselect">select plant:</h4>

					
						<div id="plantDiv" class="selectStyle">

							<select id="plantSelect" class="form-control" name="plant">
								<cfloop query="getCompany">
									<option value="#getCompany.company_id#">#getCompany.company#</option>
								</cfloop>
								<option value="all">ALL</option>
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
			
			
		
		
		<div id="resultWarning" style="display: none"><span><i class="fas fa-exclamation-circle"></i> Searching by company can return a high volume of rows to the CSV, potentially slowing it down. It is advised to limit the total rows on older computers.</span></div>
		
<!---		<span id="refreshNote" style="display: none">Last updated: #DateFormat(getLastUpdate.created,"mm.dd.yyyy")# 5:00am</span>--->
		
		<div id="notifyBox">
			<span id="notifyMessage"></span>
		</div>
		
		<div id="resultRow" class="row">
			<div class="col-sm-12" >
				<div style="position: absolute; left: 50%; top: 17vh">
					<div class="loaderDiv" style="position: relative; left: -50%; text-align: center;display: none">
						<div class="loader"><img src="/all_images/CC/blue_loading.png"></div>
						<span id="loader-label" class="noselect"><span id="loaderText">Getting data</span> <span class="loader__dot">.</span><span class="loader__dot">.</span><span class="loader__dot">.</span></span>
					</div>
				  </div>
				
				
		
				<div id="reportTabs" class="container" style="margin-top: 20px;display: none">	
					<ul  class="nav nav-tabs nav-justified">
						<li class="active">
							<a  href="##1a" data-toggle="tab"><span id="tabhdr1" class="tabtitle">Results: Unique Trips by Warehouse</span></a>
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
						<div class="tab-pane" id="2a">
							<span style="font-weight: bold;background-color: rgba(254, 255, 55,0.5)">Graph:</span>
							<div id="chartSelect">
								<div class="btn-group">
									<button type="button" class="form-control btn btn-default dropdown-toggle" data-toggle="dropdown">
										<span id="selectedChart">MSF Shipped: Warehouse Transfers</span> <span class="caret"></span>
									</button>
									<ul id="chartMenu" class="dropdown-menu" role="menu">
										
										<li><a href="##" data-showdiv="WhsTotalMSFDiv">MSF Shipped: Warehouse Transfers</a></li>
										<li><a href="##" data-showdiv="WhsNumberTripsDiv">Number Trips: Warehouse Transfers</a></li>
										<li><a href="##" data-showdiv="WhsAvgMSFTripDiv">Average MSF / Trip: Warehouse Transfers</a></li>
		
										
									</ul>
								</div>
							</div>
							
							<img src="/all_images/common/exportGraph2.gif" width="85px"  id="graphImg">
							
<!---
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

						 	
								<div id="WhsTotalMSFDiv" class="chartDiv activeChart"></div>
				  			
							
								<div id="WhsNumberTripsDiv" class="chartDiv"></div>
							
								
								<div id="WhsAvgMSFTripDiv" class="chartDiv"></div>
							
				  			

							
						</div>
					</div>
				  </div>				
		
			</div>	
		</div> <!--- resultRow --->
	</div> <!--- container --->
	
	
	
	
	<div class="modal fade" id="filterModal">
	  <div class="modal-dialog" role="document" style="width: 300px !important">
		<div class="modal-content">
			<div class="modal-header">
				<h3 class="modal-title" id="filterModalTitle" style="text-align: center">Advanced Search</h3>
			</div>
		  <div class="modal-body">

			<form action="whsxferutil.cfm" method="put" name="advancedFilterForm" id="advancedFilterForm">


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
	</div> <!--- filterModal --->
	
	

	
</cfoutput>	
<script src="/WebServices/all_includes/jquery/jquery-2.2.4.min.js"></script>
<script src="/js/Bootstrap/bootstrap_3_3_6/bootstrap.min.js"></script>
<script src="/WebServices/all_includes/basicTypeahead/jquery.typeahead.min.js"></script>
<script src="/WebServices/all_includes/datetimepicker/jquery.datetimepicker.full.min.js" type="text/javascript" charset="utf-8"></script>
<script src="/WebServices/all_includes/webuipopover/jquery.webui-popover.js" type="text/javascript"></script>
<script src="/WebServices/all_includes/DataTables/datatables.min.js" type="text/javascript"></script>
<script src="/WebServices/all_includes/DataTables/dataTables.buttons.min.js" type="text/javascript"></script>
<script src="/WebServices/all_includes/DataTables/buttons.html5.min.js" type="text/javascript"></script>
<script src="/WebServices/all_includes/DataTables/buttons.flash.min.js" type="text/javascript"></script>

<!---<script src="/WebServices/all_includes/DataTables/dynamicHeight/dataTables.pageResize.min.js" type="text/javascript"></script>--->
<!---<script src="/WebServices/all_includes/timelinejs/timeline.min.js" type="text/javascript"></script>--->

<!--- Highcharts --->
<script src="/WebServices/all_includes/Highcharts-6/code/highcharts.js"></script>
<script src="/WebServices/all_includes/Highcharts-6/code/modules/series-label.js"></script>
<script src="/WebServices/all_includes/Highcharts-6/code/modules/exporting.js"></script>
<script src="/WebServices/all_includes/Highcharts-6/code/modules/export-data.js"></script>
<!--- Additional files for the Highslide popup effect --->
<!---
<script src="https://www.highcharts.com/media/com_demo/js/highslide-full.min.js"></script>
<script src="https://www.highcharts.com/media/com_demo/js/highslide.config.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="https://www.highcharts.com/media/com_demo/css/highslide.css" />
--->
<script type="text/javascript">
	
	$('#introPanel').css("top",$('.navbar-fixed-top').outerHeight() + "px");
	
	$(document).ready(function(){
		
		var areweready = 1;
		
//		var firstRunItem = 1;
//		var firstRunTicket = 1;

		//intro
		setTimeout(function(){
			$('#reportTitleDiv > div').fadeOut();

			setTimeout(function(){
				$('#reportTitleDiv').css({"z-index":"9999","position":"absolute"});
				$('#reportTitleDiv').css({"transform":"translate(0, 0)"});
				$('#reportTitleDiv').css({"margin-left":"-40px","margin-top":"-46px","left":"inherit","top":" "});
				$('#reportTitle').css({"transform":"scale(0.5)"});
				setTimeout(function (){
					$('#introPanel').css({"animation":"fadeBG ease 1s"});
					$('#reportTitle').css({"color":"#fff","text-indent":"40px"});
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
		
		
		
		
		//init datepickers
		$("#dateStartInput").datetimepicker({
			timepicker:false,
			format:'m/d/Y'
		});	
		$("#dateEndInput").datetimepicker({
			timepicker:false,
			format:'m/d/Y'
		});	
		
		
		
		//fix datatables column alignment on tab change
		$('a[data-toggle="tab"]').on('show.bs.tab', function (e) {
			  setTimeout(function ()
			  {
				thisTable.columns.adjust().draw();
			  }, 0 );
		});
		
		
		
		//DROPDOWNS
		
		
		// Select Report
		
		$('#reportMenu a').on('click', function(){
			
			//get location
			var location = $(this).data("location");
	
			var thisUrlString = '/webservices/reports/global/' + location + '.cfm'
			
			window.location = thisUrlString;
				
			
		});

		
		//  Select Chart
		
		var CHART_VARS = ["WhsTotalMSFChart","WhsNumberTripsChart","WhsAvgMSFTripChart"];
		var thisSelectedDiv;
		var lastSelectedDiv = "WhsTotalMSFDiv";
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
				$('#titleIcon').removeClass('fas fa-chevron-down').addClass('fas fa-warehouse');
			},100);
		});
		
		
		//Report Title Hover Swap Icon
		$('.hoverspinner').mouseenter(function(){
			if($('#reportTitle').hasClass('clicked') == false){
				$('#titleIcon').css("transform","rotate(-360deg)");
				setTimeout(function(){
					$('#titleIcon').removeClass('fas fa-warehouse').addClass('fas fa-chevron-down');
				},75);
			}
		}).mouseleave(function(){
			if($('#reportTitle').hasClass('clicked') == false){
				$('#titleIcon').css("transform","rotate(0deg)");
				setTimeout(function(){
					$('#titleIcon').removeClass('fas fa-chevron-down').addClass('fas fa-warehouse');
				},75);
			}
		});
		
		//sortSelect
		$('#sortMenu a').on('click', function(){    
			
			//update dropdown with current selection
			$('.dropdown-toggle > #selectedSort').html($(this).html());

		});
		
		


		//show amtech option
//		$('#emailCSV').change(function() {
//			if (this.checked) {
//				$('#includeAmtechContainer').fadeIn("fast").css("display","inline-flex");
//			} else {
//				$('#includeAmtechContainer').fadeOut("fast");
//				$('#includeAmtech').prop('checked', false);
//			}
//		});
//		
		
		
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


		//popovers
//		$('#rowThresholdInfo').webuiPopover({title:'Row Breakpoint',content:'Number of table rows displayed until the next breakpoint. Lower values increase performance, while higher values display more data at one time.',trigger:'hover',animation:'pop',width:250});
		
//		$('#TableStyleInfo').webuiPopover({title:'Group',content:'Arrange data in a different way.',trigger:'hover',animation:'pop',width:250});
		
//		$('#sortInfo').webuiPopover({title:'Sort',content:'Sort data by a specific column.',trigger:'hover',animation:'pop',width:250});
		

		var thisTable;
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
				var startDate;
				var endDate;
				
				//adv input vars
				var emailCSV = 0;
				

				if (values.plant != "") {

					$('#resultTable').hide();
					plant = values.plant;

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
							url: "whsxferutil_CFC.cfc?method=doSearch",
							dataType: "text",
							data: {
								plant: plant,
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
									
									
									$('#resultTable > thead').html('<tr><th style="border-top-left-radius: 5px"><div align="right" class="noselect">Delivery Date</div></th><th><div align="right" class="noselect">Plant</div></th><th><div align="right" class="noselect">Trailer</div></th><th ><div align="center" class="noselect">TripNo</div></th><th><div align="right" class="noselect">Transfer</div></th><th style="border-top-right-radius: 5px"><div align="left" class="noselect">MSF C-Flute Equivalent</div></th></tr>');
									
									$('#resultTable > tfoot').html('<tr><th></th><th></th><th></th><th id="uitems"><div align="center">' + total_trips + '</div></th><th></th><th id="total"><div align="left">' + total_shipped_msf + '</div></th></tr>');
									
									var exportTitle = 'WhsXferUtil_' + startDate + '__' + endDate;




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
									
									var CHART_TYPES = ['WhsTotalMSF','WhsNumberTrips','WhsAvgMSFTrip'];
									//'CustTotalMSF','CustNumberTrips'
									
									
									var thisChartType;
									var thisChartDiv;
									var rightMargin;
									
									//loop to get data and create charts
									for(var i = 0; i < CHART_TYPES.length; i++){
	
										
										thisChartType = CHART_TYPES[i];
										thisChartDiv = CHART_TYPES[i] + 'Div';
										
										
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
											url: "whsxferutil_CFC.cfc?method=getChartData",
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
	//											var link = document.createElement('a');
	//											link.setAttribute('href', 'data:text/plain,' + json);
	//											link.setAttribute('download', 'json.txt');
	//											link.click();

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

													
													//creating many charts with same variable name...Bad practice because only the final chart in the loop will be reference-able
													
													window[CHART_VARS[i]] = Highcharts.chart(thisChartDiv, 
													{

														chart: {
															scrollablePlotArea: {

															},
															marginRight: rightMargin,
															type: 'column',
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
																		return Highcharts.numberFormat(this.y,0);
																	}
																}
															}
														},
														exporting: { enabled: true },

														series: data_obj
												});
											

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
