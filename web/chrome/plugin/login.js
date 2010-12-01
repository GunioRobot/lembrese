var pl = function(){
	var init = function(){
		$('#login form').submit(tryLogin);
		
	},
	tryLogin = function(){
		var me = $(this), xpost = me.serialize();

		$('#message').text('carregando').css('color', 'gray');
		$('#x').append('<p style="background-color: black;border:1px solid white;color:white;">push</p>');

		$.ajax({
			type:'POST',
			dataType:'json',
			cache: false,
			data: xpost,
			url: 'http://api.lembre.se:3000/login/',
			success:  function(o) {

				$('#message').text(o.msg).css('color', 'green');

				$('#x').append('<p style="background-color: black;border:1px solid white;color:white;">sucess</p>');
			},
			error: function (a, b){
				$('#message').text('Erro no ajax: ' + a.status + ' + ' + b).css('color','red');
				$('#x').append('<p style="background-color: black;border:1px solid white;color:white;">error</p>');
			},
			complete: function() {
				me.find('button,input').removeAttr('disabled');
				$('#x').append('<p style="background-color: black;border:1px solid white;color:white;">complete</p>');
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