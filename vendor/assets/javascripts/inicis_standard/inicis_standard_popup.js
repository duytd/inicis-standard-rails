document.write("<html><body style='margin:0;padding:0;border:0;outline:0;margin:0;padding:0;overflow:hidden;resize:none;'><iframe frameborder='0' scrolling='auto' id='iniStdPayPopupIframe' name='iniStdPayPopupIframe' style='border: none #FFFF00 0px;display:block; left:0; top:0px;overflow:hidden;width:660px;height:590px;margin:0px auto;'><iframe></body></html>");

if(opener.INIStdPay.$formObj == null){
	opener.INIStdPay.popupClose();
	self.close();
}

opener.INIStdPay.popupCallback();



// ë¶€ëª¨ì°½ê³¼ì˜ ì—°ê²°ì´ ëŠì–´ì§€ë©´ ì°½ ë‹«ìž„
setInterval(function(){

	if(opener.INIStdPay.$stdPopup == null) {
		self.close();
	}

}, 8000);


// ì·¨ì†Œ ë²„íŠ¼ í´ë¦­ì‹œ
var INIStdPay = {
		viewOff : function(){
			opener.INIStdPay.popupClose();
			self.close();
		}
};
