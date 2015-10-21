//-------------------------------------------------------------------------------------------
// $jINI script ê°€ browser ì— ë¡œë”©ë˜ì–´ ìžˆì§€ ì•Šìœ¼ë©´ ë¡œë”© ì‹œí‚¤ë„ë¡ í•œë‹¤. (ëª¨ë“  ë¸Œë¼ìš°ì € í˜¸í™˜)
// Created by Inicis(ehBang)
//-------------------------------------------------------------------------------------------

var INIopenDomain = "https://stdpay.inicis.com/";

var INImsgTitle = {
	info : "[INIStdPay Info] "
	,dev_err : "[INIStdPay / Dev. Error]\n\n"
};
var INImsg = {
		alert : function(msg) {
				alert(msg);
		}
		,info1		: INImsgTitle.info		+ "INIStdPay ë¼ì´ë¸ŒëŸ¬ë¦¬ë¥¼ ë¡œë”©ì¤‘ìž…ë‹ˆë‹¤.\nìž ì‹œë§Œ ê¸°ë‹¤ë ¤ ì£¼ì‹­ì„¸ìš”"
		,dev_err1	: INImsgTitle.dev_err	+ "ë™ì¼í•œ ì´ë¦„ì˜ form ê°ì²´ê°€ ì¡´ìž¬í•©ë‹ˆë‹¤."
		,dev_err2	: INImsgTitle.dev_err	+ "form ê°ì²´ë¥¼ ì°¾ì„ìˆ˜ ì—†ìŠµë‹ˆë‹¤."
		,dev_err3	: INImsgTitle.dev_err	+ "í•„ìˆ˜ ë³€ìˆ˜(#)ê°€ ì¡´ìž¬í•˜ì§€ ì•ŠìŠµë‹ˆë‹¤."
		,dev_err4	: INImsgTitle.dev_err	+ "ë³€ìˆ˜(#)ì˜ ê°’ì´ ì—†ìŠµë‹ˆë‹¤."
		,dev_err5	: INImsgTitle.dev_err	+ "ë³€ìˆ˜(#1)ì˜ ê°’ì— ê¸¸ì´ ë¬¸ì œê°€ ìžˆìŠµë‹ˆë‹¤.\n\n(ê°’:#2)\n(ê¸¸ì´:#3)\n(ì œí•œê¸¸ì´:#4)"
		,dev_err6	: INImsgTitle.dev_err	+ "í†µì‹ ì— ì‹¤íŒ¨í•˜ì˜€ìŠµë‹ˆë‹¤.\nìž ì‹œí›„ ë‹¤ì‹œ ì‹œë„í•´ë³´ì‹œê¸° ë°”ëžë‹ˆë‹¤."
		,dev_err7	: INImsgTitle.dev_err	+ "ì„ íƒëœ ê²°ì œìˆ˜ë‹¨ì€ ê³„ì•½ë˜ì§€ ì•Šì€ ê²°ì œ ìˆ˜ë‹¨ìž…ë‹ˆë‹¤."
		,dev_err8	: INImsgTitle.dev_err	+ "payViewTypeë¥¼ popupìœ¼ë¡œ ì„¤ì •í•œ ê²½ìš° ë°˜ë“œì‹œ popupUrlë¥¼ ìž…ë ¥í•´ì•¼ í•©ë‹ˆë‹¤."
		,dev_err9	: INImsgTitle.dev_err   + "í• ë¶€ì •ë³´ì— ëŒ€í•œ ê°’ì´ ì¡´ìž¬í•˜ì§€ ì•ŠìŠµë‹ˆë‹¤."
		,dev_err10 	: INImsgTitle.dev_err	+ "ì¹´ë“œì½”ë“œê°€ ìž…ë ¥ë˜ì§€ ì•Šì•˜ìŠµë‹ˆë‹¤."
};

var paramList = [
		"mid"			+":String,1~10"
		,"oid"			+":String,1~40"
		,"price"		+":Number,1~64"
		//,"goodsName"	+":String,1~20"
		//,"buyerName"	+":String,1~20"
		,"currency"		+":String,3"
		,"buyertel"		+":String,1~20"
		,"buyeremail"	+":String,1~60"
		,"timestamp"	+":String,1~20"
		//,"signature"	+":String,1~64"
		//,"signature"	+":String,64"
		,"returnUrl"	+":String,1~100"
		//,"payViewType"	+":String,1~10"
		//,"payMethod"	+":String,1~15"
];



var INIUtil = {

	randomKey : function(str) {
		return str +"_"+ (Math.random() * (1 << 30)).toString(16).replace('.', '');

	}

};

var $jINIBrowser = {

		underIE9 : function() {
				var rv = -1; // Return value assumes failure.

				var re = null;

				var ua = navigator.userAgent;

				if(navigator.appName.charAt(0) == "M"){

					re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");

					if (re.exec(ua) != null){
						rv = parseFloat(RegExp.$1);
					}

					if(rv <= 8 || document.documentMode == '7' ||  document.documentMode == '8'){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}

			}

};

var $jINILoader = {
		_startupJob : null

		,load: function(startupFunc) {
			_startupJob = startupFunc;

			if(this.$jINILoadChecker()) {
				_startupJob();
			}
			else {


				var jsUrl = INIopenDomain+'./stdjs/INIStdPay_third-party.js'
				
				if($jINIBrowser.underIE9()){
					var jsUrl = INIopenDomain+'./stdjs/INIStdPay_third-party_under_ie9.js'
				}

				var fileref=document.createElement('script');
				fileref.setAttribute("type","text/javascript");
				fileref.setAttribute("src", jsUrl);
				fileref.onload = _startupJob;
				document.getElementsByTagName("head")[0].appendChild(fileref);

				if (navigator.userAgent.toUpperCase().indexOf("MSIE")>-1){
					this.waitForJQueryLoad();
				}
			}

		}
		,waitForJQueryLoad: function () {
			setTimeout(function() { if(!$jINILoader.$jINILoadChecker()) { $jINILoader.waitForJQueryLoad(); } else { _startupJob(); }
			}, 100);
		}
		,$jINILoadChecker: function () { try {var win = $jINI(window); return true;}catch(ex){ return false; } }
		//,$jINILoadChecker: function () {return false; }

	};

var $jINICSSLoader = {
		loadDefault: function(startupFunc) {

				$jINI("<link></link>").attr({
							href: INIopenDomain+'./stdcss/INIStdPay.css',
							type: 'text/css',
							rel: 'stylesheet'
					}).appendTo('head');

			//$jINI.getScript(INIopenDomain+'./stdcss/INIStdPay.css', function(data, textStatus){   });
		}
};


var INIStdPay = {

		vForm : null
		,vIframeName		: null
		
		//,vDefaultCharset	: "EUC_KR"
		,vDefaultCharset	: "UTF-8"
		,vPageCharset		: null
		,vPayViewType		: "overlay"

		,vMethod : "POST"
		,vActionUrl			: INIopenDomain + "payMain/pay"				// ê²°ì œì°½ URL
		,vCheckActionUrl	: INIopenDomain + "jsApi/payCheck"		


		,vParamSHA256Hash	: ""											// í•„ìˆ˜ íŒŒë¼ë¯¸í„° í•´ì‰¬

		,boolInitDone 			: false		// initì´ ì •ìƒ ì‹¤í–‰ë˜ì—ˆëŠ”ì§€ ì €ìž¥
		,boolSubmitRunCheck		: false		// Submitì´ ì‹¤í–‰ ë¬ëŠ”ì§€ ì—¬ë¶€ ì²´í¬
		,boolPayRequestCheck 	: false		// íŒŒë¦¬ë¯¸í„° ì²´í¬ìš© URLë¡œ ì „ì†¡ ì—¬ë¶€ payRequestCheck()ì˜ í•´ì„œ ì‚¬ìš©
		,boolMobile				: false		// ëª¨ë°”ì¼ ì—¬ë¶€ ì²´í¬
		,boolWinMetro			: false		// MetroStyle ì—¬ë¶€ ì²´í¬
        ,boolViewParentWindow   : true      // ë¶€ëª¨ì°½ì´ ë³´ì¼ê¹Œìš”? ì•Šë³´ì¼ê¹Œìš”?
		,intMobileWidth			: 0			// ëª¨ë°”ì¼ ë„ˆë¹„

		,$formObj			: null		// form Object
		,$iframe			: null		// iframe Object
		,$iframe2			: null		// iframe Object
		,$modalDiv			: null		// ê²°ì œì°½ ë ˆì´ì–´ Object
		,$overlay			: null		// ê²°ì œì°½ ì˜¤ë²„ë ˆì´ êµ¬ì—° Object($jINI Tools Overlay Object)

		,$modalDivMsg	: null
		,$stdPopup			: null
		,$stdPopupInterval	: null
		,frmobj             : null   //ljhì¶”ê°€

		// INIStdPay ë¼ì´ë¸ŒëŸ¬ë¦¬ ì´ˆê¸°í™”
		,init : function() {
			if (!window.$jINI) {
				$jINILoader.load( function() {
					//INImsg.alert ('loaded $jINI Version:' + $jINI.fn.jquery );
					INIStdPay.init();
				});
				return;
			}else{
				//INImsg.alert ('loaded $jINI Version:' + $jINI.fn.jquery );
			};

			//$jINI.getScript(INIopenDomain+'./js/jquery.tools.min.js', function(data, textStatus){   });

			$jINI(document).ready(function(){

				$jINICSSLoader.loadDefault();

				$jINI("body").prepend(INIStdPay.$modalDiv);
				$jINI("body").append(INIStdPay.$modalDivMsg);
//				$jINI("body").append(INIStdPay.$modalDivMsg2);

				INIStdPay.boolMobile = $jINI.mobileBrowser;

				// windows 8 ì¼ë•Œ ì²´í¬
				if("msie" == $jINI.ua.browser.name){

					try {
							new ActiveXObject("");

					}
					catch (e) {
						// FF has ReferenceError here
						if (e.name == 'TypeError' || e.name == 'Error') {

						}else{
							INIStdPay.boolMobile = true;
							INIStdPay.boolWinMetro = true;
						}

					}
				}

				if(!INIStdPay.boolMobile){
					INIStdPay.INIModal_init();
				}
				//ljh test
//				setTimeout(function() { INIStdPay.boolInitDone = true; }, 7000);
				INIStdPay.boolInitDone = true;
/*
				alert($jINI.ua.browser.name)
				alert($jINI.ua.browser.version)
				alert($jINI.ua.platform.name)
				alert($jINI.ua.platform.version)
				//alert($jINI.browser.versionNumber)
*/
			});


		}

		// ëª¨ë‹¬ ì´ˆê¸°í™” ì„¸íŒ…
		,INIModal_init : function(){

			// ì˜¤ë²„ë ˆì´ì— ë“¤ì–´ê°ˆ ëª¨ë‹¬ DIV ì„¤ì •
			INIStdPay.vIframeName = INIUtil.randomKey("iframe");
			
			INIStdPay.$iframe = $jINI("<iframe name='"+INIStdPay.vIframeName+"' id='iframe'></iframe>")
							.addClass("inipay_iframe")
							.attr("frameborder","0")
							.attr("scrolling","no")
							.attr("allowtransparency","true");
			var modalCloseBtn = $jINI('<div class="inipay_close"><img src="'+INIopenDomain+'/img/close.png"></div>');

			modalCloseBtn.click(function(){
				INIStdPay.viewOff();
			});

			//var modalDivContant_header	= $jINI("<div>").addClass("inipay_modal-header").append(modalCloseBtn).append('<h3>KG Inicis Standard Payment</h3>');
			var modalDivContant_header	= $jINI("<div>").addClass("inipay_modal-header").append(modalCloseBtn);
			var modalDivContant_body 	= $jINI("<div>").addClass("inipay_modal-body").append(INIStdPay.$iframe);
			var modalDivContant_footter = $jINI("<div>").addClass("inipay_modal-footer");


			INIStdPay.$modalDiv = $jINI('<div id="inicisModalDiv" class="inipay_modal hide fade" tabindex="-1" role="dialog" aria-hidden="true"></div>');
			INIStdPay.$modalDivMsg = $jINI('<div id="inicisModalDivMsg" class="inipay_modal_msg hide fade" tabindex="-1" role="dialog" aria-hidden="true"></div>');

			INIStdPay.$modalDivMsg.html("<div style='padding:5px;'><b>ê²°ì œ íŒì—…ì°½ì„ ë‹«ì„ ê²½ìš° ì•½ 5ì´ˆí›„ ìžë™ì„ í™”ë©´ ë³µêµ¬ë©ë‹ˆë‹¤.</b></div><div style='padding:5px;'>(í˜„ìž¬ì°½ì„ ìƒˆë¡œê³ ì¹¨, ë‹«ê¸°, íŽ˜ì´ì§€ì´ë™ í•˜ëŠ” ê²½ìš° ê²°ì œì°½ì€ ìžë™ìœ¼ë¡œ ì¢…ë£Œë©ë‹ˆë‹¤.)</div>");

			INIStdPay.$modalDivMsg2 = $jINI('<div id="inicisModalDivMsg" class="inipay_modal_msg hide fade" tabindex="-1" role="dialog" aria-hidden="true"></div>');

			INIStdPay.$modalDivMsg2.html("<div style='padding:5px;'><b>ê²°ì œ ëª¨ë“ˆ ë¡œë”©ì¤‘ìž…ë‹ˆë‹¤.</b></div><div style='padding:5px;'>(ìµœëŒ€ 1ë¶„ ê°€ëŸ‰ ì†Œìš”ë˜ë©° í˜„ìž¬ì°½ì„ ìƒˆë¡œê³ ì¹¨, ë‹«ê¸°, íŽ˜ì´ì§€ì´ë™ í•˜ëŠ” ê²½ìš° ê²°ì œ ì˜¤ë¥˜ê°€ ë°œìƒ í•  ìˆ˜ ìžˆìŠµë‹ˆë‹¤.)</div>");
			// ì½”ë„ˆì²˜ë¦¬
			//INIStdPay.$modalDiv.corner("cc:#757575 25px");;

			INIStdPay.$modalDiv.append(modalDivContant_body)
				//.append(modalDivContant_footter);



			INIStdPay.$modalDiv.modal({
				keyboard: false
				,backdrop : 'static'
				,show : false
				,remote:false
			});


			INIStdPay.$modalDivMsg.modal({
				keyboard: false
				,backdrop : 'static'
				,show : false
				,remote:false
			});

			INIStdPay.$modalDivMsg2.modal({
				keyboard: false
				,backdrop : 'static'
				,show : false
				,remote:false
			});
/*
			// ì˜¤ë²„ë ˆì´ êµ¬ì—°
			INIStdPay.$overlay = INIStdPay.$modalDiv.overlay({
				mask: {
					// you might also consider a "transparent" color for the mask
					color: '#000',

					// load mask a little faster
					loadSpeed: 1000,

					// very transparent
					opacity: 0.5
				}
				,fixed:true
				,top: "center"
				,left: "center"
				,effect: "default"
				,closeOnClick: false
				,closeOnEsc:false
				,onClose : INIStdPay.viewOffTriger

			});
*/
		}
		,waitInit : function(){
//			console.log("waitInit!!");
			if(INIStdPay.boolInitDone){
				INIStdPay.pay(INIStdPay.frmobj); 
			}else{
				setTimeout(function() {INIStdPay.waitInit();}, 100);
			}
		}
		// ì´ˆê¸°í™” ì™„ë£Œ ì—¬ë¶€ ì²´í¬
		,init_check : function(call_f){
//			console.log("init_check!!");
			if(!INIStdPay.boolInitDone){

				INIStdPay.waitInit();
//				INImsg.alert(INImsg.info1)
//				return false;
			}else{
//				console.log("true!!!!");
				return true;
			}

		}

		// ê²°ì œì°½ í‘œì‹œ
		,viewOn : function(){


			$jINI(document).bind("dragstart", function(e) {
				return false;
			});
			$jINI(document).bind("selectstart", function(e) {
				return false;
			});
			$jINI(document).bind("contextmenu", function(e) {
				return false;
			});

			if(INIStdPay.init_check("INIModal_viewOn")){

				try{
					INIStdPay.$modalDiv.find(".header").html(INIStdPay.$formObj.find("[name=header]").val());
					INIStdPay.$modalDiv.find(".footer").html(INIStdPay.$formObj.find("[name=footer]").val());
				}catch(e){

				}
							
				INIStdPay.$modalDiv.modal('show');
			}




		}
		,hide : function(){
			INIStdPay.$modalDiv.modal('hide');
		}
		// ê²°ì œì°½ ìˆ¨ê¸°ê¸°
		,viewOff : function(){

			INIStdPay.$modalDiv.modal('hide');
			INIStdPay.$modalDiv.remove();
			INIStdPay.$modalDivMsg.modal('hide');
			INIStdPay.$modalDivMsg.remove();
			INIStdPay.$modalDivMsg2.modal('hide');
			INIStdPay.$modalDivMsg2.remove();
			INIStdPay.viewOffTriger();

		}


		// ê²°ì œì°½ ìˆ¨ê¸°ê¸°
		,viewOffTriger : function(){

			INIStdPay.$iframe.attr("src","");
			INIStdPay.INIModal_init();			// Modal ìž¬ ì´ˆê¸°í™”

			$jINI(document).unbind("dragstart");
			$jINI(document).unbind("selectstart");



			//$jINI(document).unbind("contextmenu");


		}

		/*
		,getBasicInfoResult : function(type, jsonData){

			if("BASIC_INFO"==type){
				$jINI(jsonData["resultData"]).each(function(){
					INImsg.alert(this.mid)
				});
			}
			//INImsg.alert(2)

		}
		*/
        
		// ê²°ì œì°½ í˜¸ì¶œ
		,pay : function(obj){
			INIStdPay.frmobj = obj
			if(INIStdPay.init_check("INIpaySubmit")){

				INIStdPay.vMethod ="POST";

				if(!INIStdPay.formCheck(obj)){
					return false;
				}else if(!INIStdPay.paramCheck(INIStdPay.$formObj)){
					return false;
				}else{

					if(INIStdPay.$formObj != null){
						
//						var newURL = window.location.protocol + "//"  + window.location.host+"/"; //  + "|" + window.location.pathname;
//						newURL = newURL.substring(0,newURL.indexOf("|"));
//						console.log(">>>> " + newURL);
						
						//ì‹œê·¸ë‹ˆì³ìƒì„± í›„ 
						//INIStdPay.getSignature(INIStdPay.$formObj.serialize());
						// ì •ë³´ ì¡°íšŒí›„
						//INIStdPay.getBasicInfo("BASIC_INFO", INIStdPay.$formObj.serialize(), INIStdPay.submit);
						
						//í”ŒëŸ¬ê·¸ì¸ìœ¼ë¡œ ì‚¬ìš©ë  payMethod êµ¬ë¶„
						/*INIStdPay.boolViewParentWindow = INIStdPay.bUsePlugin();
						if(INIStdPay.boolViewParentWindow == false){
							return;
						}*/		
						//
						INIStdPay.checkBoolView(INIStdPay.$formObj.serialize());
						
						
					}

				}

			}

		}

        // í…ŒìŠ¤íŠ¸ìš© get ê²°ì œì°½ í˜¸ì¶œ
		,payGet : function(obj){

			if(INIStdPay.init_check("INIpaySubmit")){

				INIStdPay.vMethod ="GET";

				if(!INIStdPay.formCheck(obj)){
					return false;
				}else if(!INIStdPay.paramCheck(INIStdPay.$formObj)){
					return false;
				}else{

					if(INIStdPay.$formObj != null){
						// ì •ë³´ ì¡°íšŒí›„
						INIStdPay.getBasicInfo("BASIC_INFO", INIStdPay.$formObj.serialize(), INIStdPay.submit);
					}

				}

			}

		}

		// ì²´í¬ìš© URLë¡œ ì „ì†¡
		,payReqCheck : function(obj){


			INIStdPay.boolPayRequestCheck = true;

			INIStdPay.pay(obj);


		}


		// ê²°ì œì°½ POST í˜¸ì¶œ
		,submit : function(jsonData, status, jqXHR ){

			//if("0000"==jsonData['resultCode']){

				/*
				// ê²°ì œìˆ˜ë‹¨ ì²´í¬
				var payMethod = INIStdPay.$formObj.find("input[name=payMethod]").val();


				if(payMethod.length > 0){
					if(payMethod == "card"){
						payMethod = "Card:Vcard:";
					}

					if(payMethod == "easypay" && "1" == jsonData['use_easypay']){
						payMethod = "Card:Vcard:";
					}else if(jsonData['paymethod'].indexOf(payMethod) < 0){
						INImsg.alert(INImsg.dev_err7);
						return;
					}
				}
				*/
				INIStdPay.submitBefore();				
				// Direct optionì˜ ê²½ìš° popupTypeë„ overlayì²˜ëŸ¼ ì§„í–‰ ìˆ¨ê¹€
				if(!INIStdPay.boolMobile && ((INIStdPay.vPayViewType == "overlay" && ! INIStdPay.boolPayRequestCheck) || (!INIStdPay.boolViewParentWindow && ! INIStdPay.boolPayRequestCheck))){
					INIStdPay.$formObj.attr("target",INIStdPay.vIframeName);
					// ê²°ì œì°½ ë„ìš°ê¸°
					if(INIStdPay.boolViewParentWindow){
						INIStdPay.viewOn();
						INIStdPay.$modalDivMsg2.modal('hide');
					}else{
						INIStdPay.viewOn();
//						INIStdPay.$modalDivMsg2.modal('show');
						INIStdPay.$modalDiv.hide();
					}
					
				}else if(!INIStdPay.boolMobile && INIStdPay.vPayViewType == "popup" && ! INIStdPay.boolPayRequestCheck){

						if($jINI.trim(INIStdPay.$formObj.find("input[name=popupUrl]").val()).length <= 0){
							INImsg.alert(INImsg.dev_err8);
							return false;
						}					
						
						INIStdPay.$formObj.find("input[name=popupUrl]").val();

						INIStdPay.$modalDivMsg.modal('show');

						//-------------------------------------
						//ë¶„ê¸°ì²˜ë¦¬ í•„ìš” - ë„¤ì´ë²„ nik íŒì—…ì¸ ê²½ìš° : íŒì—…ì°½ì— ë§žê²Œ ì‚¬ì´ì¦ˆ ì¡°ì ˆ ë¶ˆê°€í”¼./// by yang 2015-10-02 
						//-------------------------------------
						
						/*ìˆ˜ì • ì†ŒìŠ¤ START*/
						/**	ê¸°ì¡´ ì†ŒìŠ¤ START 
						//window.showModalDialog("./popup.jsp", window, "dialogWidth:660px;dialogHeight:590px;center:yes;status:no;help:no;resizable:no;scroll:no");
						INIStdPay.$stdPopup = window.open(INIStdPay.$formObj.find("input[name=popupUrl]").val(),"iniStdPayPopupIframe","width=750,height=500,resizable=no,scroll=yes,left="+(screen.availWidth-660)/2+",top="+(screen.availHeight-590)/2+",modal=yes");
						//window.open('', '', ''left='+',top='+', width=660px,height=430px');
						ê¸°ì¡´ ì†ŒìŠ¤ END */

						var y_gopaymethod = INIStdPay.$formObj.find('input[name=gopaymethod]').val();
						var y_acceptmethod = INIStdPay.$formObj.find('input[name=acceptmethod]').val();
						
						if (('onlycard' == y_gopaymethod || 'onlyvbank' == y_gopaymethod ) && (-1 != y_acceptmethod.indexOf('site_id(nik)')) ) {	//naver nik ë¬´í†µìž¥ , ì‹ ìš©ì¹´ë“œì¸ê²½ìš° í™”ë©´ì— ë§žê²Œ íŒì—…Size ì¡°ì •í•¨. 
							INIStdPay.$stdPopup = window.open(INIStdPay.$formObj.find("input[name=popupUrl]").val(),"iniStdPayPopupIframe","width=390,height=480,resizable=no,scroll=no,left="+(screen.availWidth-660)/2+",top="+(screen.availHeight-590)/2+",modal=yes");
						} else {
							INIStdPay.$stdPopup = window.open(INIStdPay.$formObj.find("input[name=popupUrl]").val(),"iniStdPayPopupIframe","width=750,height=500,resizable=no,scroll=yes,left="+(screen.availWidth-660)/2+",top="+(screen.availHeight-590)/2+",modal=yes");
						}
						/*ìˆ˜ì • ì†ŒìŠ¤ END*/
						
						INIStdPay.$stdPopupInterval = setInterval(function(){

							if(typeof(INIStdPay.$stdPopup)=='undefined' || INIStdPay.$stdPopup.closed) {
								clearInterval(INIStdPay.$stdPopupInterval);

								INIStdPay.popupClose();

							}

						}, 5000);

						return;

				}else{

					if(INIStdPay.vPayViewType == "new"){
						INIStdPay.$formObj.attr("target","_top");
					}else{
						INIStdPay.$formObj.attr("target","_self");
					}

				}


				INIStdPay.$formObj.submit();

				INIStdPay.submitAfter();

			/*
			}else{
				INImsg.alert(jsonData['resultCode'] +" | "+ jsonData['resultMsg']);
				return false;
			}
			*/
		}
		,popupCallback : function(){
			
			
			INIStdPay.$formObj.attr("target","iniStdPayPopupIframe");

			INIStdPay.$formObj.submit();
			INIStdPay.submitAfter();
			
			

		}
		,popupClose : function(){

			INIStdPay.$modalDivMsg.modal('hide');
			INIStdPay.$modalDivMsg.remove();

			INIStdPay.viewOffTriger();

		}

		,submitBefore : function(){

			var $input;

			if($jINI("input[name=requestByJs]").size() >0 ){
				$input = INIStdPay.$formObj.find("input[name=requestByJs]");
			}else{
				$input = $jINI("<input/>")
							.attr("name", "requestByJs")
							.attr("type", "hidden")
				INIStdPay.$formObj.append($input);
			}

			$input.val("true");



			if("" == $jINI.trim(INIStdPay.$formObj.find("[name=payViewType]").val())){
				INIStdPay.$formObj.find("[name=payViewType]").val("overlay");
			}

			INIStdPay.vPayViewType = $jINI.trim(INIStdPay.$formObj.find("[name=payViewType]").val());
			
//			// ActionUrl ì„¸íŒ…
//			if(INIStdPay.boolPayRequestCheck){
//				INIStdPay.$formObj.attr("action",INIStdPay.vCheckActionUrl);
//			}else{
				INIStdPay.$formObj.attr("action",INIStdPay.vActionUrl);
//			}

			// method ì„¸íŒ…
			INIStdPay.$formObj.attr("method",INIStdPay.vMethod);

			INIStdPay.$formObj.attr("accept-charset",INIStdPay.vDefaultCharset);

			// charset ì„¸íŒ…
			if(document.all){
				INIStdPay.vPageCharset = document.charset;
				try {
					document.charset = INIStdPay.vDefaultCharset;
				} catch (e) {
					// TODO: handle exception
				}

			}

		}
		,submitAfter : function(){
			INIStdPay.$formObj = null;


			// íŒŒë¼ë¯¸ë” í…ŒìŠ¤íŠ¸ ì „ì†¡ ì²´í¬ ìƒíƒœ ë³µê·€
			INIStdPay.boolPayRequestCheck = false;

			// charset ì›ìƒë³µêµ¬
			if(document.all){
				try {
					document.charset = INIStdPay.vPageCharset;
				} catch (e) {
					// TODO: handle exception
				}

			}

		}

		// í¼ ê°ì²´ ì¡´ìž¬ ì—¬ë¶€ì²´í¬
		,formCheck : function(obj){

			if($jINI(obj).is("form")){
				INIStdPay.$formObj = $jINI(obj);
			}else if($jINI("#"+obj).is("form")){
				INIStdPay.$formObj = $jINI("#"+obj);
			}else if($jINI("[name="+obj+"]").is("form")){

				if($jINI("[name="+obj+"]").size() > 1){
					INImsg.alert(INImsg.dev_err1);
					return false;
				}

				INIStdPay.$formObj = $jINI("[name="+obj+"]");

			}else{
				INImsg.alert(INImsg.dev_err2);
				return false;
			}
			return true;
		}

		// íŒŒë¼ë¯¸í„° ìœ íš¨ì„± ì²´í¬
		,paramCheck : function(){

			var paramCheckStatus = true;

			//var ParamHashValue = "";

			$jINI(paramList).each(function(){

				vName = this.split(":")[0];

				vType = this.split(":")[1].split(",")[0];
				vLength = this.split(":")[1].split(",")[1];

				$obj = INIStdPay.$formObj.find(":input[name="+vName+"]");
				
				
				// currencyê°’ì´ "" ì¼ê²½ìš° WONìœ¼ë¡œ ê°•ì œ ì ìš©
				if(vName=="currency" && $obj.val().length <= 0 ){INIStdPay.$formObj.find("[name=currency]").val("WON");}
				
				if($obj.size() <= 0){
					INImsg.alert(INImsg.dev_err3.replace("#",vName));
					paramCheckStatus = false;
					return false;	// eachì¤‘ì§€ìš©
				}else if($obj.val().length <= 0){
					INImsg.alert(INImsg.dev_err4.replace("#",vName));
					paramCheckStatus = false;
					return false;	// eachì¤‘ì§€ìš©
				}else{
					if(vLength.indexOf("~") >= 0){

						var vLengthStart = vLength.split("~")[0];
						var vLengthEnd	 = vLength.split("~")[1];

						if($obj.val().length < Number(vLengthStart) || $obj.val().length > Number(vLengthEnd)){
							INImsg.alert(INImsg.dev_err5.replace("#1",vName).replace("#2",$obj.val()).replace("#3",$obj.val().length).replace("#4",vLength));
							paramCheckStatus = false;
							return false;	// eachì¤‘ì§€ìš©
						}
					}else{
						if($obj.val().length > Number(vLength)){
							INImsg.alert(INImsg.dev_err5.replace("#1",vName).replace("#2",$obj.val()).replace("#3",$obj.val().length).replace("#4",vLength));
							paramCheckStatus = false;
							return false;	// eachì¤‘ì§€ìš©
						}
					}

				}

				//ParamHashValue += $obj.attr("name")+"="+$obj.val()+"&";

			});

			//vParamSHA256Hash = hex_sha256(ParamHashValue);

			//INIStdPay.addHashparam();

			return paramCheckStatus;

		}

		// íŒŒë¼ë¯¸í„° í•´ì‰¬ê°‘ ìƒì„±
/*
		,addHashparam : function(){

			var $input;

			if($jINI("input[name=scriptHash]").size() >0 ){
				$input = INIStdPay.$formObj.find("input[name=scriptHash]");
			}else{
				$input = $jINI("<input/>")
							.attr("name", "scriptHash")
							.attr("type", "hidden");

				INIStdPay.$formObj.append($input);
			}

			$input.val(vParamSHA256Hash);

		}
*/
		// ì •ë³´ ì¡°íšŒ
		,getBasicInfo : function(type, paramJson, callback_f){

			paramJson['callback'] = "?";

			$jINI.ajax({
				asyn : true
				, url:INIopenDomain+'jsopenapi/basicInfo'
				, data : paramJson
				, dataType:"jsonp"
				, contentType:"application/x-www-form-urlencoded;charset=UTF-8"
				, success:callback_f
				, error:function(jqXHR,status,errorThrown ){
						INIStdPay.jsonpError(type,jqXHR,status,errorThrown);
					}
				, complete:function(jqXHR,status){
					}
			});
		}
		,jsonpError : function(type, jqXHR, status, errorThrown ){

			INImsg.alert(INImsg.dev_err6);

		}
		,checkBoolView : function(param){
			
			var gopaymethod  = INIStdPay.$formObj.find(":input[name=gopaymethod]").val().toLowerCase();
			var acceptmethod = INIStdPay.$formObj.find(":input[name=acceptmethod]").val();
			var cardCode	 = INIStdPay.$formObj.find(":input[name=ini_cardcode]").val();
			if(acceptmethod != null){
				//ì—¬ê¸°ì„œ gopaymethodì™€ site_idê°€ ì¡´ìž¬í•˜ëŠ”ì§€ ì²´í¬ gopaymehod ='onlydbank' site_idëŠ” ì¡´ìž¬ ì—¬ë¶€ë§Œ..
				var beginIndex  = acceptmethod.indexOf("site_id(");
				var temp = acceptmethod.substring(beginIndex + 8,acceptmethod.length);
				var endIndex = temp.indexOf(")");
				var site_id = temp.substring(0, endIndex);
				
				if(site_id.length > 0 ){
					if(site_id == "wmk" || site_id == "nikom" || site_id == "tmon"|| site_id == "nik"){
						if(gopaymethod == "onlydbank"){
							$JSImport.load(INIopenDomain+"./stdjs/importPri.js", function(){
								fn_submit();
							});
							return;
						}
					}
				}
			}
			//onlyisp ì™€ onlyacard ìž…ë ¥ì‹œì—ë§Œ
			if(gopaymethod == "onlyisp" || gopaymethod == "onlyacard" || gopaymethod == "onlyvcard"){
				if(acceptmethod.indexOf("cardonly") !=  -1){
					if("" != cardCode){
						param['callback'] = "?";
						
						$jINI.ajax({
							
							 url: INIStdPay.vCheckActionUrl
							, type : "POST"
							, data : param
							, dataType:"jsonp"
							, jsonp : "callback"
							, contentType:"application/x-www-form-urlencoded;charset=UTF-8"
							, success:function(jsonData,status,errorThrown){
								if(jsonData.resultCode == "0000"){
									if(jsonData.acceptData != null){
										INIStdPay.$formObj.find("input[name=acceptmethod]").val(jsonData.acceptData);
									}
									if(jsonData.viewState =="on"){
										INIStdPay.submit();	
										INIStdPay.boolViewParentWindow = true
									}else{
										//íŒì—…ìƒíƒœì´ë©´ ì˜¤ë²„ë ˆì´ë¡œ ë³€ê²½ ì²˜ë¦¬(Directì˜µì…˜ì¼ê²½ìš°)
										INIStdPay.boolViewParentWindow = false
										INIStdPay.submit();
									}
																	
								}else{									
									INImsg.alert(jsonData.resultMsg);
									INIStdPay.viewOff();
								}
							}
							, error:function(jqXHR,status,errorThrown ){
									alert("[Connection Failure] : "+errorThrown);
									INIStdPay.viewOff();
								}
							, complete:function(jqXHR,status){
								
								}
						});
						
					}else{
						INImsg.alert(INImsg.dev_err10);
						INIStdPay.viewOff();
					}
					
				}else{
					INIStdPay.boolViewParentWindow = true
					INIStdPay.submit();
				}
			}else if (gopaymethod == "onlyhpp"){
				//íŒì—…ìƒíƒœì´ë©´ ì˜¤ë²„ë ˆì´ë¡œ ë³€ê²½ ì²˜ë¦¬(Directì˜µì…˜ì¼ê²½ìš°)
				
				INIStdPay.boolViewParentWindow = false	
				INIStdPay.submit();
			}else{
				INIStdPay.boolViewParentWindow = true
				INIStdPay.submit();
			}
		}
		
/*
		function start(objForm) {

			this.vForm = objForm;


			return false;
		}

		function submit(str) {

			this.init();
			this.vForm = objForm;
			this.viewOn();

			return false;
		}



		function INIModal_viewOn(){
			INImsg.alert(INIModal.scrollHeight())
		}

		function INIModal_viewOff(event){
			INImsg.alert(INIModal.scrollHeight())
		}
*/


};
 
var $JSImport = {
        load : function(_url, callback) {
                 if (_url == undefined)
                        return;
                 if (_url.indexOf('.js') != -1) {
                	 
                        var head = document.getElementsByTagName('head').item(0);
                        var script = document.createElement('script');
                        script.type = 'text/javascript';
                        script.charset = "utf-8";
                        script.onload = function() {
                                if (callback != undefined) {
                                        callback();
                                }
                        }
                        
                      //for IE Browsers
                     // IE8ì—ì„œ htmlDataê°€ jQuery().html()ë¡œ ì„¤ì •ë ë•Œ ê¹¨ì§€ëŠ” ë¬¸ì œê°€ ë°œìƒí•œ ê²ƒìž„.
                    	if(navigator.userAgent.indexOf("MSIE 8.0") > -1 || navigator.userAgent.indexOf("MSIE 7.0") > -1|| document.documentMode == '7' ||  document.documentMode == '8') {
                    		ieLoadBugFix(script, function(){
                            	callback();
                            });
                    	
                    	}

                       function ieLoadBugFix(scriptElement, callback){

                               if (scriptElement.readyState=='loaded'  || scriptElement.readyState=='complete') {
                                    callback();
                                }else {
                                    setTimeout(function() {ieLoadBugFix(scriptElement, callback); }, 100);
                                }
                        }
//                        
                        
                       $jINI.cachedScript = function( url, options ) {
                          // Allow user to set any option except for dataType, cache, and url
                          options = $jINI.extend( options || {}, {
                            dataType: "script",
                            cache: true,
                            url: url
                          });
                          // Use $.ajax() since it is more flexible than $.getScript
                          // Return the jqXHR object so we can chain callbacks
                          return $jINI.ajax( options );
                        };
//                        // Usage
                        $jINI.cachedScript( _url ).done(function( script, textStatus ) {
                        });
                        
                        script.src = _url;
                        head.appendChild(script);

                }
        }
}

window.name = "INIpayStd_Return";


INIStdPay.init();
