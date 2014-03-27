/* Coach Gizmo scripts */

"use stict;"

// globals object

var globals = {
	sportKey 		: '',
	sportName 		: '',
	currentTeam 	: '',
	currentTeamID 	: '',
	lib 			: '',
	currentPlayer 	: '',
	currentPlayerID	: '',
	activationCode	: ''
};

function commit() {
	globals.lib.commit();
		
	// commit the entire localStorage database to cloudant
	if ( globals.currentTeam != '' ) {
		clouddb.saveData(globals.currentTeam, globals.lib.serialize());
	}
	var obj = {
		activationCode : globals.activationCode
	};

	/* items that we want pre-loaded on every app load */
	localStorage.setItem("CoachGizmo_globals", JSON.stringify(obj));
}

String.prototype.capitalize = function () {
    return this.replace(/^./, function (char) {
        return char.toUpperCase();
    });
};

/** generic password checker **/

$(document).on("tap", ".checkFields", function() {

	// email field checker
	var fieldId = $(this).attr('emailField');
	var fieldObj = $('#'+fieldId);
	var emailVal = jQuery.trim(fieldObj.val());
	var emailValid = true;
	
	if ( emailVal != undefined ) {
		if ( /^\w+([\.\+-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,7})+$/.test(emailVal) == false ) {
			emailValid = false;
		}
	}

	fieldId = $(this).attr('passwordField');
	fieldObj = $('#'+fieldId);
	
	var passValid = true;
	var passVal = jQuery.trim(fieldObj.val());
			
	re = /[0-9]/;
	if(!re.test(passVal)) {
		passValid = false;
		log('password must contain a number');
	}
	re = /[!@#$%^&*()-]/;
	if(!re.test(passVal)) {
		passValid = false;
		log('password must have a special character');
	}
	re = /[a-z]/;
	if(!re.test(passVal)) {
		passValid = false;
		log('password must have a lower-case letter');
	}
	re = /[A-Z]/;
	if(!re.test(passVal)) {
		passValid = false;
		log('password must have an upper-case letter');
	}
	if ( passVal < 8 ) {
		passValid = false;
		log('password must have at least 8 characters');
	}
	
	if ( passValid && emailValid ) {
		var formToSubmit = $(this).attr('submitForm');
		var functionToCall = $(this).attr('callFunction');
		
		if ( formToSubmit != undefined ) {
			$("#"+formToSubmit).submit();
		}
		if ( functionToCall != undefined ) {
			var fn = window[functionToCall];
			if ( typeof fn === 'function' ) {
				fn();
			}
		}
		
		$.mobile.navigate("#chooseSport");
	}
	else if ( !emailValid ) {
		//$.mobile.navigate("#emailAlert", { transition: "pop" } );
		$("#activateEmailAlert").trigger("click");
	}
	else {
		//$.mobile.navigate("#passwordAlert", { transition: "pop" } );
		$("#activatePasswordAlert").trigger("click");
	}
});

function trim(val) {
	return jQuery.trim(val);
}

function guid() {
    function _p8(s) {
        var p = (Math.random().toString(16)+"000000000").substr(2,8);
        return s ? "-" + p.substr(0,4) + "-" + p.substr(4,4) : p ;
    }
    return _p8() + _p8(true) + _p8(true) + _p8();
}

function openURL(url) {
	alert(url);
}

$(document).on("tap", "#assignToTeam, #removeFromTeam", function() {
	var srcObj, destObj;
	var tappedBtnID = $(this).attr('id');

	if ( tappedBtnID == 'assignToTeam' ) {
		srcObj = $("#availablePlayers a");
		destObj = $("#assignedPlayers");
	}
	else {
		srcObj = $("#assignedPlayers a");
		destObj = $("#availablePlayers");
	}

	srcObj.each(function() {
		if ( $(this).hasClass('ui-btn-b') ) {
			var lineToChange = $(this).parent();
			
			// fetch the localstorage row ID and assign to team
			var itemID = $(this).attr('id');
			var teamID = globals.currentTeamID;
			
			if ( tappedBtnID == 'assignToTeam' ) {
				globals.lib.update('players', {ID: itemID}, function(row) {
					row['team'] = row['team'] + teamID + '|';		
					return row;
				});
			}
			else {
				globals.lib.update('players', {ID: itemID}, function(row) {
					row['team'] = row['team'].replace('|' + teamID + '|', '|');		
					return row;
				});
			}

			// assign this person to this team
			
			destObj.prepend(lineToChange.clone());
			
			lineToChange.remove();
			
			$("#assignedPlayers").listview('refresh');
			$("#availablePlayers").listview('refresh');
			
			$("#assignedPlayers a").removeClass('ui-btn-b');
			$("#availablePlayers a").removeClass('ui-btn-b');
		}
	});
	
	commit();
});

/* highlighted selected list item when tapped */

$(document).on("tap", "ul li a", function () {
	$(this).parent().parent().find('a').removeClass('ui-btn-b');
	$(this).addClass('ui-btn-b');
});

$(document).on("tap", "#btnAddPlayer", function() {
	var playerName = $("#txtPlayerName").val();
	var sportsList = "";
	var sportsIcons = "";
	var playerGuid = guid();
	var sport = '';
	var sportsString = '|';
	var teamsString = '|';

	$("#playerSports input").each(function() {
		if ( $(this).is(":checked") ) {
			sport = $(this).attr('id');
			sportsIcons += "<img src='../images/icons-small/" + sport + ".png' />";
			sportsString += sport + '|';
		}
	});	
	
	var line = $('ul#lstCurrentPlayers li.ui-first-child').clone().addClass(playerGuid).removeClass('hidden');

	$('ul#lstCurrentPlayers').append(line);
	
	if ( playerName == '' ) {
		playerName = "(unnamed)";
	}
	
	// add the player to the localstorage db
	var playerID = globals.lib.insert("players", {name: playerName, team: teamsString, sport: sportsString, jersey: 11, age: 20, exp: 13, rank: 4, phone: "", email: "", pname: "", pemail: "", pphone: "" });
	
	commit();
	
	// fetch the new player ID
	
	$('.' + playerGuid + ' a').html("<div class=playerName ID=" + playerID + ">" + playerName + "</div><div class=iconList>" + sportsIcons + "</div>");
	
	$('ul#lstCurrentPlayers').listview('refresh');
});

$(document).on("tap", "#btnCreateTeam", function() {

	console.log("btnCreateTeam globals");
	console.log(globals);

	var newTeam = $("#txtNewTeamName").val();
		
	if ( newTeam == '' ) {	
		// show popup error
		$("#noTeamNamePopup").trigger("click");
	}
	else {
		globals.currentTeam = newTeam;
		
		//console.log(globals);
		
		/* fetch the values of "added fields" */
		
		var dataToSave = new Object();
		
		dataToSave.name = globals.currentTeam;
		dataToSave.gender = $("#gender").val();
		dataToSave.league = $("#league").val();
		dataToSave.sport = globals.sportKey;
		
		var addedData = new Object();
		
		var i = 0;
		
		$("#createTeam .added-field").each(function() {
			addedData[$(this).attr('name') + '_' + i++] = $(this).val();
		});
		
		dataToSave.xdata = addedData;
			
		var teamID = globals.lib.insert("teams", dataToSave);
		
		globals.currentTeamID = teamID;
		
		
		commit();
		
		$.mobile.navigate('#addPlayers');
	}
});

$(document).on("tap", "#lstCurrentPlayers li, .playerName", function() {

	var playerLine = $(this).find('.playerName');
	
	/* this is a player button in the "Assigned Players" list on home screen */
	if ( playerLine.length == 0 ) {
		playerLine = $(this);
		
		/* we need to load the team/sport as well */
		globals.currentTeamID = $(this).attr('teamID');
		
		var teamObj = sportdb.getTeam(globals.currentTeamID);
		
		/* populate some globals based on the currentTeamID */
		globals.currentTeam = teamObj.name;
		globals.sportKey = teamObj.sport;
	}
	
	var playerName = playerLine.html();
	var playerID = playerLine.attr('ID');
	
	globals.currentPlayer = playerName;
	globals.currentPlayerID = playerID;
});

$(document).on("tap", "#createTeam", function() {

	var newSportKey = $("#selChooseSport").val();
	var newSportName = $("#selChooseSport option:selected").text();
	
	if ( newSportKey != undefined ) {
		globals.sportKey = newSportKey; //$("#selChooseSport").val();
		globals.sportName = newSportName; //$("#selChooseSport option:selected").text();

		/* forces add mode for the create team page */
		globals.currentTeamID = false;
	}
});

/* tap event for "Edit" button next to "Team Data" */
$(document).on("tap", "#editTeamData", function() {
	globals.sportKey = $(this).attr('sportKey');
	globals.currentTeamID = $(this).attr('teamID');
});

/*
<select name="playerAge" class="selectRange" rangeStart="4" rangeEnd="99" class="db" dbtable="players" dbfield="age" dbref="txtPlayerInfoName"></select>
*/

$(document).on('expand', '.team-row', function() {
	var teamID = $(this).attr('id');
});

// executed before any page is shown
$(document).on('pagebeforeshow', function() {

	var pageID = $.mobile.activePage.attr('id');
	
	if ( pageID == 'homeLoggedIn') {
		$("#sports-tab-1").trigger('tap');
		//$("ul").listview();//.listview('refresh');
		
		/* init jQueryMobile button styles */
		//$('.playerName').trigger('create');
	}
	else if ( pageID == 'createTeam' ) {
		/* check to see if we are editing an existing team, or creating a new team */
		
		if ( globals.currentTeamID > 0 ) {
			console.log('editing an existing team' );
			
			var teamObj = sportdb.getTeam(globals.currentTeamID);
			
			globals.currentTeam = teamObj.name;
			// globals.sportKey = teamObj.sport;
			
			$("#setupGameTeam h2").html("Edit team: " + teamObj.name);
			
			$("#txtNewTeamName").val(teamObj.name);
			$("select#gender").val(teamObj.gender);
			$("select#league").val(teamObj.league);
			
			/* need to add the 'xdata' field data */
		}
	}
	
	/* replace any DOM objects with class "globals" with the global var */
	$("#" + pageID + " .globals").each(function() {
		var globalVar = $(this).attr('var');
		
		if ( $(this)[0].tagName == 'SPAN' )
			$(this).html(globals[globalVar]); // a span tag
		else
			$(this).val(globals[globalVar]); // an input box
			
		// what about select lists??
	});
	
	/* A field list (select, fieldset, etc) that must be populated from the javascript data file */
	$("#" + pageID + " .jsdata").each(function() {

		var selectObj = $(this); /* this may be a fieldset, list, or select list */
		var selectObjType = $(this).attr('type');
		
		console.log("selectObjType = " + selectObjType);
		
		if ( selectObjType == undefined ) {
			console.log(selectObj);
		}
		
		var dbKey1 = $(this).attr('key1');
		var dbKey2 = $(this).attr('key2');
		
		if ( selectObjType == 'radio' ) {
			console.log("dbKey1 = " + dbKey1 );
			console.log("dbKey2 = " + dbKey2 );
		}
		
		var dataToPopulate = "";
				
		if ( dbKey1 != undefined ) {
			if ( dbKey1.indexOf("globals.") != -1 ) {
				dbKey1 = dbKey1.replace("globals.", "");
				dbKey1 = globals[dbKey1];
			}
		}
	
		if ( dbKey2 != undefined ) {
			if ( dbKey2.indexOf("globals.") != -1 ) {
				dbKey2 = dbKey2.replace("globals.", "");
				dbKey2 = globals[dbKey2];
			}
		
			dataToPopulate = data[dbKey1][dbKey2];
		
		}
		else {
			dataToPopulate = [];
			
			for ( var i in data[dbKey1] ) {
				dataToPopulate.push( [i, data[dbKey1][i]] );
			}
		}
		
		var optionsValues = "";
		var i = 0;
		var selected = "";
		var checked = "";
		var radioClass = "";
		
		$.each(dataToPopulate, function() {
			//selectObj.append($("<option />").val(this).text(this));
			++i;
			
			selected = (i <= 1) ? "selected" : "";
			checked = (i <= 1) ? " checked=checked " : "";
			
			if ( Array.isArray(this) ) {
			
			/*
		 <input type="radio" name="radio-choice-2" id="radio-choice-1" value="choice-1" checked="checked">
<label for="radio-choice-1">Cat</label>	
			*/
			
				/* this is a complex value list, like "fields" */
				
				if ( selectObjType == 'radio' ) {
				
					/* we don't have any of these right now */
					
				}
				else {
					/* default to select list */
					optionsValues += "<option fieldtype='" + this[1][1] + "' fieldsize='" + this[1][2] + "' " + selected + " value='" + this[0] + "'>" + this[1][0] + "</option>";
				}
			}
			else {
				/* this is a simple value list */
				if ( selectObjType == 'radio' ){
				
					if ( i == 1 ) {
						radioClass = "ui-first-child";
					}
					else if ( i == dataToPopulate.length ) {
						radioClass = "ui-last-child";
					}
					else {
						radioClass = "";
					}
				
					optionsValues += '<input type="radio" id="' + this + '" name="' + dbKey2 + '" value="' + this + '" ' + checked + ' /><label class="' + radioClass + '" for="' + this + '">' + this + '</label>';
				}
				else {
					optionsValues += "<option " + selected + " value='" + this + "'>" + this + "</option>";
				}
			}
		});
		
		
		
		if ( selectObjType == 'radio' ) {
		
			selectObj.html('<div class="ui-controlgroup-controls">' + optionsValues + "</div>");
		
			selectObj.find('input').each(function() {
				$(this).checkboxradio();
				$(this).checkboxradio('refresh');
			});
		}
		else if ( selectObjType == 'select' ) {
			selectObj.html(optionsValues);
			selectObj.selectmenu("refresh");
		}
	});
	


	/* An input or select that must be populated from the database */
	$("#" + pageID + " .db").each(function() {
	
		var tagName = $(this)[0].tagName;
	
		if ( tagName == 'INPUT' || tagName == 'SELECT' ) {
	
			var keyValue;
			var dbTable = $(this).attr('dbtable');
			var dbField = $(this).attr('dbfield');
		
			if ( dbTable == 'players' ) 
				keyValue = globals.currentPlayerID;
			else if ( dbTable == 'teams' ) 
				keyValue = globals.currentTeamID;
			
			var res = globals.lib.query(dbTable, {ID: keyValue});

			if ( res[0] != null && res[0] != undefined ) {
			
				var fieldNewValue = res[0][dbField];
		
				$(this).val(fieldNewValue);
			
				/* this needs more work to populate select lists from database */
				if ( tagName == 'SELECT' ) {
					$(this).selectmenu('refresh');
				}
			}
		}
	});
	
	/*
	if ( globals.sportKey != '' ) {
		$("#" + pageID + " .jsdata").each(function() {
			var jsDataKey = $(this).attr('key');
		
			if ( jsDataKey == 'positions' ) {
				var positions = data.positions[globals.sportKey];
			
				for ( var i = 0; i < positions.length; i++ ) {
					// dynamically populate select list with positions
					$(this).append('<option value="' + positions[i] + '">' + positions[i] + '</option>');
				}
				
				$(this).selectmenu('refresh');
			}
		});
	}
	*/
	
	$("#" + pageID + " .dblist").each(function() {
		var dbTable = $(this).attr('dbtable');
		var dbField = $(this).attr('dbfield');
		var listObj = $(this);
		
		listObj.html(""); ///???
		
		var res = globals.lib.query(dbTable, function(row) {
			if ( pageID == 'addPlayers' ) {
					
				var sportsString = row['sport'];
				var sportsIcons = '';
				
				if ( sportsString != null && sportsString != undefined ) {
					var sportsArr = sportsString.split('|');
				
					for( var i in sportsArr ) {
						if ( sportsArr[i] != "" ) {
							sportsIcons += "<img src='../images/icons-small/" + sportsArr[i] + ".png' />";
						}
					}
				}
			
				listObj.append('<li><a href="#viewPlayer"><div class=playerName ID=' + row['ID'] + '>' + row[dbField] + '</div><div class=iconList>' + sportsIcons + '</div></a></li>');
			}
			else {
				listObj.append('<li><a href="#" ID=' + row['ID'] + '>' + row[dbField] + '</a></li>');
			}
		});
					
		if ( listObj.find('li').length == 0 ) {
			listObj.append('<li class="hidden temp viewPlayer"><a href="#viewPlayer">&nbsp;</a></li>');
		}
		
		
		$(this).listview('refresh');
	});
});

/* The "add data" option in creating a team */
$(document).on('tap', "#addDataBtn", function() {
	var obj = $("#addData :selected");
	
	var fieldKey = obj.val();
	var fieldText = obj.text();
	var fieldSize = obj.attr('fieldsize');
	var fieldType = obj.attr('fieldtype');
	
	var fieldData = '<div class="ui-input-text ui-body-inherit ui-corner-all ui-shadow-inset">' + "<input data-inline=true type=text size=" + 1 + " name=" + fieldKey + " class='added-field field-" + fieldKey + "'></div>";
	

	$("#addDataRow").before("<tr><td>" + fieldText + ":</td><td>" + fieldData + "</td></tr>");
});

$(document).on("tap", ".dbupdate", function() {

	var pageID = $.mobile.activePage.attr('id');

	$("#" + pageID + " .db").each(function() {
	
		var tagName = $(this)[0].tagName;
	
		if ( tagName == 'INPUT' || tagName == 'SELECT' ) {
	
			// determine the primary key field
			var dbTable = $(this).attr('dbtable');
			var dbField = $(this).attr('dbfield');
			var dbFieldNewValue = $(this).val();
			
			if ( dbTable == 'players' ) 
				keyValue = globals.currentPlayerID;
			else if ( dbTable == 'teams' ) 
				keyValue = globals.currentTeamID;
					
			globals.lib.update(dbTable, {ID: keyValue}, function(row) {
				row[dbField] = dbFieldNewValue;				
				return row;
			});
		}
	});
	
	commit();
});

function initDB() {
	/* Initialise. If the database doesn't exist, it is created */
	var dbname = globals.activationCode;
	
	//console.log("initDB with dbname = " + dbname);
	
	var lib = new localStorageDB(dbname, localStorage);
	
	globals.lib = lib;
	globals.dbname = dbname;
	
	clouddb.init(dbname); /* create or open remote connection */
	
	// Check if the database was just created. Useful for initial database setup
	if( globals.lib.isNew() ) {

		// create the "teams" table
		globals.lib.createTable("teams", ["name", "gender", "sport", "league", "xdata"]);	
		
		// create additional tables
		globals.lib.createTable("players", ["name", "team", "sport", "jersey", "age", "exp", "rank", "phone", "email", "pname", "pphone", "pemail"]);
		
		globals.lib.createTable("games", ["field", "team", "location", "date", "time", "environ", "field", "hscore", "ascore", "environ1", "environ2", "environ3", "environ4", "refh", "ref1", "ref2"]);

		commit(); /* commits local and remote */
	}
}

$(document).on("tap", "#activateAccount2", function() {
	globals.activationCode = trim($("#activateCode").val());
	
	initDB();
});

// populate any select list ranges
$(document).ready(function() {
	var rangeStart, rangeEnd, rangeInc, i;

	$(".selectRange").each(function() {
		rangeStart = parseInt($(this).attr('rangeStart'));
		rangeEnd = parseInt($(this).attr('rangeEnd'));
		rangeInc = parseInt($(this).attr('rangeInc'));
		
		if ( rangeInc == undefined || isNaN(rangeInc) ) {
			rangeInc = 1;
		}
				
		for( i = rangeStart; i <= rangeEnd; i += rangeInc ) {
			$(this).append('<option value="' + i + '">' + i + '</option>');
		}
		//$(this).selectmenu('refresh');
	});
	
	// set up tabbed-panel
	$(".tab").each(function() {
		if ( $(this).hasClass('open') ) {
			var panel = $(this).attr('ref');
			$("#" + panel).show();
			$(this).addClass("ui-btn-b");
		}
	});
	// tabbed panel behaviors
	$(document).on("tap", ".tab", function() {
		$(".tab-content").hide();
		var panel = $(this).attr('ref');
		$("#" + panel).show();
		$(".tab").removeClass('ui-btn-b');
		$(this).addClass('ui-btn-b');
	});
	
	var obj = localStorage.getItem('CoachGizmo_globals');
	
	if ( obj != null && obj.activationCode != '' ) {
		var savedObj = JSON.parse(obj);
		globals.activationCode = savedObj.activationCode;
		
		/* load existing database */
		initDB();
		
		var sports = new Object();

		/* build the default screen programmatically */
		globals.lib.query("teams", function(row) {
			if ( sports[row.sport] == undefined ) {
				sports[row.sport] = new Array();
			}
			sports[row.sport].push(row);
		});
		
		var sportCount = 1;
		var tabs = '';
		var accordion = '';
		var teamID = 0;
		var xdata = '';
		var parts, title;
		
		for( var i in sports ) {
			tabs += '<a id="sports-tab-' + sportCount + '" class="tab open ui-btn-b" ref="tab-sport-' + sportCount + '" data-role="button" data-inline="true">' + i.capitalize() + '</a>';
			
			accordion += '<div class="tab-content" data-expanded-icon="false" data-collapsed-icon="false" data-role="collapsible-set" id="tab-sport-' + sportCount + '">';
			//console.log(sports[i]);
			
			for ( var j in sports[i] ) {
			
				teamID = sports[i][j].ID;
			
				accordion += '<div class="team-row" id="team-' + teamID + '" data-role="collapsible" data-collapsed="true"><h3>' + sports[i][j].name + '</h3>';
				
				/* 3-column grid layout */
				accordion += '<div class="ui-grid-b">';
				
				/* column 1 */
				accordion += '<div class="ui-block-a"><h4>Team Data &nbsp;&nbsp;&nbsp;<a href="#createTeam" id="editTeamData" data-role=button data-mini=true data-inline=true teamID="' + teamID + '" sportKey="' + sports[i][j].sport + '">Edit</a></h4>';
				accordion += '<table><tr>';
				
				accordion += '<td>Girls/Boys:</td>';
				accordion += '<td>' + sports[i][j].gender + '</td>';
				accordion += '</tr><tr>';
				accordion += '<td>League:</td>';
				accordion += '<td>' + sports[i][j].league + '</td>';
	
				/* additional, custom fields */
				console.log(sports[i][j]);
				
				xdata = sports[i][j].xdata;
				
				if ( xdata != undefined ) {
					for( var xd in xdata ) {
					
						parts = xd.split('_');
						title = data.fields[parts[0]][0];
						
						accordion += '<tr><td>' + title + ':</td><td>' + xdata[xd] + '</td></tr>';
					}
				}
				
				accordion += '</tr></table></div>';
				
				/* column 2 */
				accordion += '<div class="ui-block-b"><h4>Assigned Players</h4>';
				accordion += '<p class="playerList" id="players-' + teamID + '">List of assigned players</p>';
				accordion += '</div>';
				
				/* column 3 */	
				accordion += '<div class="ui-block-c"><h4>Game Data</h4>';
				accordion += '<p id="games-' + teamID + '">Game data list</p>';
				accordion += '</div>';	
				
				/* close 3-column grid layout */
				accordion += '</div>';
				
				/* close collapsible pane */
				accordion += '</div>';
			}
			
			accordion += '</div>';
			
			sportCount++;
		}
		
		$("#sportsTabs").html(tabs);
		$("#sportsAccordion").html(accordion);
		
		$(".team-row").on("collapsibleexpand", function(event, ui) {
			/* retrieve the assigned players and game data for this team */
			var players = new Array();
			var teamID = $(this).attr('id').replace('team-', '');
			var playerList = '<div class="controlgroup" data-role="controlgroup" id="teamdata-' + teamID + '">';
			
			globals.lib.query("players", function(row) {
				if ( row.team.indexOf('|' + teamID + '|') != -1 ) {		
					console.log(row);
						
					playerList += '<a href="#viewPlayer" sport="" teamID="' + teamID + '" data-role="button" ID="' + row.ID + '" class="playerName" data-icon="arrow-r">' + row.name + ' (#' + row.jersey + ')</a>';
				}
			});
			
			playerList += '</div>';
			
			$("#players-" + teamID).html(playerList);
			
			/* initialize the jQueryMobile markup */
			$("#players-" + teamID + ' a').buttonMarkup();
			$("#players-" + teamID + ' a').addClass('ui-btn-icon-right');
			$("#teamdata-" + teamID + ".controlgroup").controlgroup();
		});
/*

	<ul id="lstCurrentPlayers" class="dblist" dbtable="players" dbfield="name" data-inset="true" data-role="listview" data-filter="true" data-filter-placeholder="Search Players...">
	</ul>

$(document).on("tap", "#lstCurrentPlayers li", function() {

	var playerLine = $(this).find('.playerName');
	
	var playerName = playerLine.html();
	var playerID = playerLine.attr('ID');
	
	globals.currentPlayer = playerName;
	globals.currentPlayerID = playerID;
});
*/
		
		$.mobile.navigate("#homeLoggedIn");
		
	}
	else {
		$.mobile.navigate("#loginRegister");
	}

});

function log(msg) {
	console.log(msg);
}