var GitTicket = {
  toggle:function(invoke_action)  {
    if (invoke_action == "show")  {
      $('#create_ticket_form').show();
      $('#ticket_title_field').value="";
      $('#ticket_body_field').value="";
      $('#ticket_priority_field').selectedindex=2;
      $('#submitting_ticket').hide();
      $('#submit_ticket').show();
    } else  {
      $('#create_ticket_form').hide();
    }
  },
  submit:function(git_ticket_form)  {
    try {
      $(git_ticket_form).ajaxSubmit({dataType: 'script'});
      
    } catch (e) {
      alert(e);
    }
    return false;
  }, 
  notify:function(message)  {
    $("#create_ticket_form form").resetForm();
    jQuery.facebox('<h1 class="facebox">'+message+'</h1>');
    setTimeout(jQuery.facebox.close, 4000);
  }
}