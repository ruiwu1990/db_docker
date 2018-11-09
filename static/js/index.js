$(document).ready(function(){
    $('#execute_button_id').click(function(){
        // get user inputted code
        var input_sql = $('#sql_command').val();
        var tmp_word = input_sql.split(' ');
        if( tmp_word[0] == 'Select' || tmp_word[0] == 'select' )
        {
            var get_url = '/api/execute_sql_display/'+input_sql;
            $.get(get_url, function(data){
                console.log('Query has been uploaded.');
                // TODO, display it as a nice table
                $('#select_result_id').text(data);
            });
        }
        else
        {
            var post_url = '/api/execute_sql/'+input_sql;
            // $.post(post_url, {query: input_sql}, function(input_sql){
            //     console.log('Query has been uploaded.');
            // });
            $.get(post_url, function(data){
                console.log('Query has been uploaded.');
                // TODO, display it as a nice table
                $('#select_result_id').text(data);
            });
        }



    });


});

