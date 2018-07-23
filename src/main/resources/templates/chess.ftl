<!DOCTYPE HTML>
<head>
    <meta charset="UTF-8"/>
    <title>五子棋</title>

</head>
<body onload="startload()" style="margin: 0px;padding: 0px">
    <canvas id="mycanvas" width="1024" height="768" onmousedown="play(event)">
    </canvas>
</body>
<script type="text/javascript">
    /**
     * 五子棋:
     * 1.如何画出棋子?
     * 2.如何保存棋子?
     */

    /**
     * 先定义全局变量
     */
    var canvas;//html5画布
    var context; //内容
    var isWhite = false;//是否为白子下，假设黑子先手
    var winner = ''; //
    var step = 225;//总步数
    var chessData = new Array(15);
    for(var x=0;x<15;x++){
        chessData[x] = new Array(15);
        for(var y=0;y<15;y++){
            chessData[x][y] = 0;//使用数组来保存棋子,初始化为0表示此处为没有棋子，1表示白棋，2表示黑棋
        }
    }
    //每次打开网页时需要执行的方法
    function startload() {
        //画出棋盘的方法
        drawRect();
    }

    //画出棋盘的方法
    function drawRect() {
        //创建棋盘的背景
       createContext();
        context.fillStyle = "#FFA500"; //背景色为黄色
        context.fillRect(0,0,1024,768); //表示矩形框的宽为1024，高为768
        //标题
        context.fillStyle = "#00f";
        context.font = "40px Arial";
        context.strokeText("我的JS五子棋",330,50);
        //新游戏
        context.strokeRect(790,140,120,30);
        context.fillStyle = "#00f";
        context.font = "25px Arial";
        context.strokeText("再来一局",800,165);
        //游戏说明
        context.fillStyle = "#00F";
        context.font = "15px Arial";
        context.strokeText('游戏规则：玩家执黑色', 780, 200);
        context.strokeText('棋子先手，电脑执白色棋子', 750, 220);
        context.strokeText('后手，任何一方形成五子连', 750, 240);
        context.strokeText('珠，游戏终止。', 750, 260);
        //棋盘的横纵线
        for(var i=1;i<16;i++){
            context.beginPath();
            context.lineWidth = "2";
            context.strokeStyle = "green";
            context.moveTo(40 * i+140, 80);
            context.lineTo(40 * i+140, 640);
            context.stroke();

            context.beginPath();
            context.lineWidth = "2";
            context.strokeStyle = "green";
            context.moveTo(180, 40 * i+40);
            context.lineTo(740, 40 * i+40);
            context.stroke();
        }


    }

    //初始化全局变量context
    function createContext() {
        var c = document.getElementById("mycanvas");
        context = c.getContext("2d");
    }

    //鼠标单击事件
    function play(e) {
        var color;
        //alert("鼠标单击了一次");
        var px = e.clientX-160;
        var py = e.clientY-60;
        console.log(px+","+py);
        /**确定点击的是第几列和第几行
         * parseInt()方法可以解析字符串
         * 并向下取整
         *
         */
        var x = parseInt(px/40);
        var y = parseInt(py/40);
        isNewGame(e.clientX,e.clientY);
        //drawChess(x,y,color);
        if(px<0 || py<0 || x>14 || y>14 || chessData[x][y] != 0){
            //console.log("点击在了棋盘的区域外");
            return;
        }

        doCheck(x,y);

    }

    function isNewGame(x,y) {
        if(x>790 && x<910 && y<170 && y>140){
            if(confirm("开始新的游戏?")){
                location.reload();
            }
        }
    }

    //给棋子上颜色
    function doCheck(x,y) {
        if(winner != null && winner != ''){ //游戏结束时只能点击开始按钮
            alert(winner);
            return;
        }
        if(isWhite){
            color = "white";
            isWhite = false; //修改下一个棋子的颜色
        }else{
            color = "black";
            isWhite = true;
        }
        console.log(color+"落子的位置"+x+","+y);
        drawChess(x,y,color);
    }


    //开始绘画棋子
    function chess(x,y,color) {
        createContext();
        context.fillStyle = color; //fillStyle的作用是给棋子填充颜色
        context.beginPath();
        context.arc(x*40+180,y*40+80,15,0,Math.PI*2,true); //绘画棋子
        context.closePath();
        context.fill();
        if(color == "white"){
            console.log("电脑在"+x+","+y+"画了个白棋");
            chessData[x][y] = 1; //修改当前位置为白棋
        }else{
            console.log("电脑在"+x+","+y+"画了个黑棋");
            chessData[x][y] = 2; //修改当前位置为黑棋
        }

    }



    //开始落子
    function drawChess(x,y,color) {
        if(x>=0 && x<15 && y>=0 && y<15){
            chess(x,y,color); //开始画棋子
            iswin(x,y,color);//判断输赢
        }
    }

    //判断输赢
    function iswin(x,y,color) {
        var temp = 2;//默认为黑色,表示当前位置为黑棋
        if(color === "white"){
            temp = 1;//表示当前位置为白棋
        }
        levelCount(x,y,temp); //进行水平方向的判断
        tbCount(x,y,temp); //竖向方向的判断
        rtCount(x,y,temp); //左斜方向的判断
        rbCount(x,y,temp); //右斜方向的判断
    }

    //水平方向的判断
    function levelCount(x,y,temp) {
            var line = new Array(4);
            var count = 0;
            for (var i = x; i >= 0; i--) { //x在改变，y不变
                line[0] = i;
                line[1] = y;
                if (chessData[i][y] == temp) {
                    ++count;
                } else {
                    i=-1;
                }
            }
            for (var i = x; i <= 14; i++) {
                line[2] = i;
                line[3] = y;
                if (chessData[i][y] == temp) {
                    ++count;
                } else {
                    i = 100;
                }
            }
            success(line[0], line[1], line[2], line[3], temp, --count);

    }

    //竖向方向的判断
    function tbCount(x,y,temp) {
        var line = new Array(4);
        var count = 0;
        for (var i = y; i >= 0; i--) {
            line[0] = x;
            line[1] = i;
            if (chessData[x][i] == temp) {
                ++count;
            } else {
                i = -1;
            }
        }
        for (var i = y; i <= 14; i++) {
            line[2] = x;
            line[3] = i;
            if (chessData[x][i] == temp) {
                ++count;
            } else {
                i = 100;
            }
        }
        success(line[0], line[1], line[2], line[3], temp, --count);
    }

    //左斜方向的判断
    function rtCount(x,y,temp) {
        var line = new Array(4);
        var count = 0;

        for (var i = x, j = y; i <= 14 && j >= 0;) {
            line[0] = i;
            line[1] = j;
            if (chessData[i][j] == temp) {
                ++count;
            } else {
                i = 100;
            }
            i++;
            j--;
        }
        for (var i = x, j = y; i >= 0 && j <= 14;) {
            line[2] = i;
            line[3] = j;
            if (chessData[i][j] == temp) {
                ++count;
            } else {
                i = -1;
            }
            i--;
            j++;
        }
        success(line[0], line[1], line[2], line[3], temp, --count);
    }
    
    //右斜方向的判断
    function rbCount(x,y,temp) {
        //右下斜判断
        var line = new Array(4);
        var count = 0;

        for (var i = x, j = y; i >= 0 && j >= 0;) {
            line[0] = i;
            line[1] = j;
            if (chessData[i][j] == temp) {
                ++count;
            } else {
                i = -1;
            }
            i--;
            j--;
        }
        for (var i = x, j = y; i <= 14 && j <= 14;) {
            line[2] = i;
            line[3] = j;
            if (chessData[i][j] == temp) {
                ++count;
            } else {
                i = 100;
            }
            i++;
            j++;
        }
        success(line[0], line[1], line[2], line[3], temp, --count);
    }

    function success(a, b, c, d, temp, count) {
        if (count == 5) { //因为落子点重复计算了一次
            console.log("此局游戏结束啦");
            console.log("(" + a + "," + b + ")" + "到" + "(" + c + "," + d + ")");

            context.beginPath();
            context.lineWidth = 5;
            context.strokeStyle = 'purple';
            context.moveTo(40 * a + 180, 40 * b + 80);
            context.lineTo(40 * c + 180, 40 * d + 80);
            context.closePath();
            context.stroke();


            winner = "黑棋胜利!";
            if (temp == 1) {
                winner = "白棋胜利!";
            }
            alert(winner);
        }
    }
</script>

