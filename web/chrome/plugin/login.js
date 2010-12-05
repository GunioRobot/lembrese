var pl = function(){
	var cur_url = '',
		init = function(){
		var $uid = localStorage["uid"];

		chrome.tabs.getSelected(null, function(tab) {
			pl.setUrl(tab.url);
			pl.bookmarkit();
		});

		if (!$uid){			
			$('#login').show().find('form').submit(tryLogin);
		}else{
			$('#message').text('Stating...').css('color', 'gray');
		}
	},
	tryLogin = function(){
		var me = $(this), xpost = me.serialize();

		$('#message').text('carregando').css('color', 'gray');

		$.ajax({
			type:'POST',
			dataType:'json',
			cache: false,
			data: xpost,
			url: 'http://api.lembre.se:3000/login/',
			success:  function(o) {
				
				if (o.err){
					$('#message').text(o.msg).css('color', 'red');
				}else{
					$('#message').text(o.msg).css('color', 'green');
					if (o.jd.uid){
						localStorage["uid"] = o.jd.uid;
						localStorage["pid"] = o.jd.pid;
						$('#login').hide();
						$('#message').text('Stating...').css('color', 'gray');
						// vai saber neh.... pc lentos.
						if (!cur_url){
							$('#message').text('Sorry, we can\'t get your current URL, please try again after close this window.').css('color', 'red');
						}else{
							pl.bookmarkit();
						}
					}
				}
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
	},
	bookmarkit = function(){

		var xpost = {
			uid: localStorage["uid"],
			pid: localStorage["pid"],
			url: cur_url
		};
		$('#message').text('Bookmarking...').css('color', 'gray');
		$.ajax({
			type:'POST',
			dataType:'json',
			cache: false,
			data: xpost,
			url: 'http://api.lembre.se:3000/bookmarkit/',
			success:  function(o) {
				if (o.err){
					$('#message').text(o.msg).css('color', 'red');
					if (o.jd.nouid){
						$('#login').show().find('form').submit(tryLogin);
					}
				}else{
					$('#message').text(o.msg).css('color', 'green');
					setTimeout( 'pl.closeWindow()',1000 );
				
				}
			},
			error: function (a, b){
				$('#message').text('Erro no ajax: ' + a.status + ' + ' + b).css('color','red');
			}
		});
	}
	;

	return {
		init: init,
		bookmarkit:bookmarkit,
		setUrl: function(u){cur_url = u;},
		closeWindow: function() {$('*').remove();window.close();}
	};
}();

$(pl.init);
