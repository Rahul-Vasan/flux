import "testing"

inData = "
#datatype,string,long,dateTime:RFC3339,dateTime:RFC3339,dateTime:RFC3339,double,string,string,string
#group,false,false,false,false,false,false,true,true,true
#default,_result,,,,,,,,
,result,table,_start,_stop,_time,_value,_field,_measurement,host
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:26Z,82.9833984375,used_percent,swap,host.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:36Z,82.598876953125,used_percent,swap,host.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:46Z,82.598876953125,used_percent,swap,host.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:56Z,82.598876953125,used_percent,swap,host.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:06Z,82.598876953125,used_percent,swap,host.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:16Z,82.6416015625,used_percent,swap,host.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:26Z,2.9833984375,used_percent,swap,host1.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:36Z,2.598876953125,used_percent,swap,host1.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:46Z,2.598876953125,used_percent,swap,host1.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:56Z,2.598876953125,used_percent,swap,host1.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:06Z,2.598876953125,used_percent,swap,host1.local
,,161,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:16Z,2.6416015625,used_percent,swap,host1.local
,,162,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:26Z,1.83,load1,system,host.local
,,162,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:36Z,1.7,load1,system,host.local
,,162,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:46Z,1.74,load1,system,host.local
,,162,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:56Z,1.63,load1,system,host.local
,,162,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:06Z,1.91,load1,system,host.local
,,162,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:16Z,1.84,load1,system,host.local
,,163,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:26Z,1.98,load15,system,host.local
,,163,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:36Z,1.97,load15,system,host.local
,,163,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:46Z,1.97,load15,system,host.local
,,163,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:56Z,1.96,load15,system,host.local
,,163,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:06Z,1.98,load15,system,host.local
,,163,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:16Z,1.97,load15,system,host.local
,,164,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:26Z,1.95,load5,system,host.local
,,164,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:36Z,1.92,load5,system,host.local
,,164,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:46Z,1.92,load5,system,host.local
,,164,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:53:56Z,1.89,load5,system,host.local
,,164,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:06Z,1.94,load5,system,host.local
,,164,2018-05-22T19:53:26Z,2018-05-22T19:54:16Z,2018-05-22T19:54:16Z,1.93,load5,system,host.local
"
outData = "
#datatype,string,long,dateTime:RFC3339,string,dateTime:RFC3339,double
#group,false,false,true,true,false,false
#default,0,,,,,
,result,table,_start,_measurement,_time,load1
,,0,2018-05-22T19:53:26Z,system,2018-05-22T19:53:26Z,1.83
,,0,2018-05-22T19:53:26Z,system,2018-05-22T19:53:36Z,1.7
,,0,2018-05-22T19:53:26Z,system,2018-05-22T19:53:46Z,1.74
,,0,2018-05-22T19:53:26Z,system,2018-05-22T19:53:56Z,1.63
,,0,2018-05-22T19:53:26Z,system,2018-05-22T19:54:06Z,1.91
,,0,2018-05-22T19:53:26Z,system,2018-05-22T19:54:16Z,1.84
"

t_select_measurement_field = (table=<-) =>
  table
  |> range(start: 2018-05-22T19:53:26Z)
  |> filter(fn: (r) => r._measurement ==  "system" and r._field == "load1")
  |> group(columns: ["_measurement", "_start"])
  |> map(fn: (r) => ({_time: r._time, load1:r._value}))
  |> yield(name:"0")

testing.test(
    name: "select_measurement_field",
    input: testing.loadStorage(csv: inData),
    want: testing.loadMem(csv: outData),
    testFn: t_select_measurement_field)