<!--                                                      -->
<!-- Copyright (c) 2010 PuzzOn.net                        --> 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head>
        <%@ include file="/head.jsp" %>
        <link rel="stylesheet" type="text/css" href="/content.css">
        <style type="text/css">
            #snapping {
                color: #F9F6F9;
                font-size: 16px;
                font-style: normal;
                font-weight: bold;
                padding: 5px;
                text-decoration: none;
                text-transform: none;
            }
            
            #stopper {
                font-size: 48px;
                font-weight: bold;
                color: #f9f6f9;
                text-align: center;
            }
            
            #next div {
                color: #E97CCD;
                font-size: 16px;
                font-style: normal;
                font-weight: bold;
                line-height: 20px;
                margin: 0px auto;
                text-decoration: none;
                text-transform: none;
            }
            
            #next img {
                cursor: pointer;
                border-style: none;
            }
        </style>
        <script type="text/javascript" language="JavaScript" src="/yui/utilities.js">     </script>
        <script type="text/javascript" language="JavaScript" src="/arena/json-min.js">        </script>
        <script type="text/javascript" language="JavaScript" src="/arena/math-min.js">        </script>
        <script type="text/javascript" language="JavaScript" src="/arena/board-min.js">       </script>
        <script type="text/javascript" language="JavaScript" src="/arena/stopper-min.js">     </script>
        <script type="text/javascript" language="JavaScript">
            
            function loadPuzzleItem(){
                Board.init();
                
                var id = '<%= request.getParameter("puzzle-item") %>';
                var callback = {
                    success: handleSuccess,
                    failure: handleFailure,
                    argument: [id, Board.width, Board.height]
                };
                
                var url = "/api/puzzle?id=" + id;
                YAHOO.util.Connect.asyncRequest("GET", url, callback, null);
            }
            
            function handleSuccess(resp){
                var id = resp.argument[0];
                var w = resp.argument[1];
                var h = resp.argument[2];
                
                try {
                    Board.polyform = JSON.parse(resp.responseText);
                    Board.validateCallback = function(r) {
                        r = JSON.parse(r.responseText);

                        Stopper.stop();
                        Board.stopPuzzling();

                        var callback = {
                            success: function(obj) {
                                 var json = JSON.parse(obj.responseText);                                
                                 
                                 var next = document.getElementById("next");                                 
                                 next.innerHTML = '<center><div><%=resources.getText("arena.greatjob")%></div><a href="?puzzle-item=' + json.next_id + 
                                                    '&locale=<%=resources.getLocale()%>"><img src="/images/next.png"></a></center>';
                            },
                            failure: function(obj) {
                                ;
                            }
                        }
                        YAHOO.util.Connect.asyncRequest("POST", "/api/score/", callback, "id=" + r.id + "&ticks=" + Stopper.ticks);
                    };
                    
                    Board.startPuzzling();                    
                    Stopper.start();
                } 
                catch (e) {
                    close();
                }
            }
            
            function handleFailure(obj){
                close();
            }
            
            function close_onMouseOver(obj){
                obj.src = "/images/close-red.png";
            }
            
            function close_onMouseOut(obj){
                obj.src = "/images/close-grey.png";
            }
            
            function close_onClick(){
                close();
            }
            
            function close(){
                window.location.replace('/?locale=' + '<%=resources.getLocale() %>');
            }
            
            function snapping_onChange(obj){
                Board.is_snapping_on = (obj.checked ? true : false);
            }
        </script>
        <!--[if IE]>
            <style type="text/css">
            .widget-dialog { padding-top: 0px; margin-top: 188px; }
            </style>
            <script type="text/javascript" language="JavaScript" src="/arena/excanvas.compiled.js"></script>
            <script type="text/javascript" language="JavaScript">
            function setOnMouseLeaveHandler() {
                Board.element.onmouseout = null;
                Board.element.onmouseleave = Board.onMouseOut;
            }
            YAHOO.util.Event.addListener(window, 'load', setOnMouseLeaveHandler);
            </script>
        <![endif]-->
    </head>
    <body onload="loadPuzzleItem();">
        <center>
            <div id="root">
                <table class="widget-dialog" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td align="left" valign="top">
                                <div class="header" style="position: relative; overflow: hidden;">
                                    <span class="title">PuzzOn Arena - puzzle #<%= request.getParameter("puzzle-item") %></span>
                                    <img src="/images/close-grey.png" class="close-button" onmouseover="close_onMouseOver(this);" onmouseout="close_onMouseOut(this);" onclick="close_onClick();">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">
                                <div class="content" style="position: relative; overflow: hidden;">
                                    <div style="position: relative; overflow: hidden; width: 770px; height: 510px;">
                                        <div style="position: absolute; left:5px; top:5px; display:block;">
                                            <canvas id="grid" width="500" height="500" style="background-color:#F9F6F9; position:absolute;">
                                            </canvas>
                                            <canvas id="board" width="500" height="500" style="background-color:transparent; position:absolute;">
                                            </canvas>
                                        </div>
                                    </div>
                                    <div id="pattern" style="position: absolute; left: 575px; top: 5px;">
                                        <img id="item" src="/images/puzzle-item-<%= request.getParameter("puzzle-item")%>.png">
                                    </div>
                                    <span style="position: absolute; left: 550px; top: 200px;">
                                        <input onchange="snapping_onChange(this);" id="cb_snapping" type="checkbox" tabindex="0" checked>
                                        <label id="snapping" for="cb_snapping">
                                            <%=resources.getText("arena.snapping")%>
                                        </label>
                                    </span>
                                    <div id="stopper" style="position: absolute; left: 545px; top: 250px;"></div>
                                    <div id="next" style="position: absolute; left: 550px; top: 400px; "></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">
                                <div class="footer" style="position: relative; overflow: hidden;">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </center>
    </body>
</html>
