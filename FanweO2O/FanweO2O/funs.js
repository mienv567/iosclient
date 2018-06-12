var App = {};

//专题
(function initialize()
 {
 App.app_detail = function (cmd,param) {
 var url ="App.app_detail.."+cmd+"&&"+param;
 document.location.href = url;
 };
 })();
