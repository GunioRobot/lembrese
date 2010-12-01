var pl = function(){
	var init = function(){
		$('#login form').submit(tryLogin);
		
	},
	tryLogin = function(){
		var me = $(this), xpost = me.serialize();

		$('#message').text('carregando').css('color', 'gray');

		$.ajax({
			type:'POST',
			dataType:'json',
			cache: false,
			data: xpost,
			url: 'http://api.lembre.se:3000/login2',
			success:  function(o) {

				$('#message').text(o.msg).css('color', 'green');


			},
			error: function (a, b){
				$('#message').text('Erro no ajax: ' + a.status + ' + ' + b).css('color','red');
			},
			complete: function() {
				me.find('button,input').removeAttr('disabled');
			},
			beforeSend: function(){ me.find('button,input').attr('disabled', 'disabled');}
		});
		 
		return false;
	};
	return {
		init: init
	};
}();

$(pl.init);