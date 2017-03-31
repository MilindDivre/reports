
var textData;
var data;
var labels = [];
var data = [];

function SE21Ready()
{
	var x;
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
	if (xhttp.readyState == 4 && xhttp.status == 200) {
		filetxt = xhttp.responseText;
	  	textData=filetxt.split("\n")
		for (i=0;i<textData.length;i++)
		{
			var temp,lab,dat;	
			var tempArr=[];
			temp = textData[i];
			tempArr = temp.split(":");
			labels[i]=String(tempArr[0]);
			data[i]=String(tempArr[1]);
		}
		console.log("in label length"+labels.length);
		//Add code here for graph
		const CHART = document.getElementById("ReadyLine");
		let linechart = new Chart(CHART,{
		type: 'horizontalBar',
		options:
		{
			legend:
			{
				display: false
			},
			tooltips: 
			{
			enabled: false
			}
		},
		options:
		{	
			responsive: true,
			scales:
			{
				xAxes:[{
				display:false,
				}]
			},
			tooltips: 
			{
			enabled: false
			},
			animation: 
			{
				duration: 0,
				onComplete: function () 
				{
					console.log("On Complete getting called");
					// render the value of the chart above the bar
					
					var ctx = this.chart.ctx;
					ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
					ctx.fillStyle = this.chart.config.options.defaultFontColor;
					ctx.textAlign = 'center';
					ctx.textBaseline = 'bottom';
					
					
					this.data.datasets.forEach(function (dataset)
					{
						for (var i = 0; i < dataset.data.length; i++) 
						{
							console.log("value of i "+ i);
							var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
							ctx.fillText(dataset.data[i], model.x + 2 , model.y +3);
						}
						
					});
					
				}
			}
		},
		data: {
		labels: labels,
		datasets: [
        {
            label: "SE21AQ Ready Status",
            fill: true,
            lineTension: 0.1,
            backgroundColor: "rgba(75,192,192,0.4)",
            borderColor: "rgba(75,192,192,1)",
            borderCapStyle: 'butt',
            borderDash: [],
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBorderColor: "rgba(75,192,192,1)",
            pointBackgroundColor: "#fff",
            pointBorderWidth: 0.5,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: "rgba(75,192,192,1)",
            pointHoverBorderColor: "rgba(220,220,220,1)",
            pointHoverBorderWidth: 1,
            pointRadius: 0.5,
            pointHitRadius: 5,
            data: data,
            spanGaps: false,
        }]
}

});	
    }
  };
  xhttp.open("GET", "SE21_ReadyStatus.txt", true);
  xhttp.send();

}

function SE21Expiered()
{
	 var x;
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (xhttp.readyState == 4 && xhttp.status == 200) {
      filetxt = xhttp.responseText;
			//console.log(filetxt);
	  	textData=filetxt.split("\n")
		//console.log(textData);
		for (i=0;i<textData.length;i++){
			var temp,lab,dat;
			
			var tempArr=[];
			temp = textData[i];
			tempArr = temp.split(":")
			//lab=tempArr[0]
			//dat=tempArr[1]
			//labels.push(lab);
			//data.push(dat);
			
			labels[i]=String(tempArr[0]);
			data[i]=String(tempArr[1]);
			
			console.log("in label"+labels[i]);
			//console.log("in data"+data[i]);
		}
		console.log("in label length"+labels.length);
		//Add code here ffor graph
		const CHART = document.getElementById("ExpiredLine");
		let linechart1 = new Chart(CHART,{
		type: 'horizontalBar',
		options:
		{
			legend:
			{
				display: false
			},
			tooltips: 
			{
			enabled: false
			}
		},
		options:
		{	
			responsive: true,
			scales:
			{
				xAxes:[{
				display:false,
				}]
			},
			tooltips: 
			{
			enabled: false
			},
			animation: 
			{
				duration: 0,
				onComplete: function () 
				{
					console.log("On Complete getting called 2");
					// render the value of the chart above the bar
					
					var ctxObj = this.chart.ctx;
					ctxObj.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
					ctxObj.fillStyle = this.chart.config.options.defaultFontColor;
					ctxObj.textAlign = 'center';
					ctxObj.textBaseline = 'bottom';
					this.data.datasets.forEach(function (dataset1)
					{
						for (var j = 0; j < dataset1.data.length; j++) 
						{
							console.log("value of j "+ j);
							var model1 = dataset1._meta[Object.keys(dataset1._meta)[0]].data[j]._model;
							ctxObj.fillText(dataset1.data[j], model1.x + 2 , model1.y +3);
						}
						
					});
					
				}
			}
		},
		data: {
		labels: labels,
		datasets: [
        {
            label: "SE21AQ Ready Expired",
            fill: true,
            lineTension: 0.1,
            backgroundColor: "rgba(75,192,192,0.4)",
            borderColor: "rgba(75,192,192,1)",
            borderCapStyle: 'butt',
            borderDash: [],
            borderDashOffset: 0.0,
            borderJoinStyle: 'miter',
            pointBorderColor: "rgba(75,192,192,1)",
            pointBackgroundColor: "#fff",
            pointBorderWidth: 0.5,
            pointHoverRadius: 5,
            pointHoverBackgroundColor: "rgba(75,192,192,1)",
            pointHoverBorderColor: "rgba(220,220,220,1)",
            pointHoverBorderWidth: 1,
            pointRadius: 0.5,
            pointHitRadius: 5,
            data: data,
            spanGaps: false,
        }]
}
});	
    }
  };
  xhttp.open("GET", "expired.txt", true);
  xhttp.send();
}



function loadDoc()
 {
	SE21Ready();
	SE21Expiered();
}






