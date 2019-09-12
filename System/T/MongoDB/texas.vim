
into outfile '/tmp/plat.sql'

select * into outfile '/tmp/2163950.sql' from role_friendtablerecords  where rid=2163950  and  record like  '%"table_room_type":10%"create_user_rid":2163950%' ;
select * into outfile '/tmp/2075173.sql' from role_friendtablerecords where rid=2075173  and  record like  '%"table_room_type":10%"create_user_rid":2075173%' ;

db.orderinfo.find({'state': 3}, {'_id':0, 'pid':1, 'pay_type':1, 'price': 1, 'good_awards':1}).pretty();


select count(*) from goods group by cat_id;
{
  key:{cat_id: 1},
  cond: {},
  reduce: function(curr, result){
    result.total += 1;
  },
  initial:{total:0}

}

> db.vegetableprice.find();
{ "_id" : ObjectId("50271b4ae02ab93d5c5be795"), "name" : "tomato",    "price" : 3.3, "time" : ISODate("2012-08-12T02:56:10.303Z") }

> db.runCommand({"group" : {
 "ns" : "vegetableprice",
 "key" : {"name" : true},
 "initial" : {"time" : 0},
 "$reduce" : function(doc, prev) {
    if(doc.time > prev.time) {
         prev.time = doc.time;
         prev.price = doc.price;
     }
 }
 }});

#用户最后离开游戏时间
db.playersonline.aggregate([{
$group:{
  _id: "$rid",
  offtime: {$last: "$offtime"}
  }
}])

db.orderinfo.aggregate([{
$group: {
  _id: "$pay_type",
  total_price: {$sum: "$price"}
  }
}])

db.orderinfo.aggregate([
  {$match: {state: {$eq: 3}}},
  {$group: { _id: "$pay_type", total_price: {$sum: "$price"}, total_count: {$sum: 1}}},
  {$sort: {total_count: 1}},
  {$limit: 1}
])

db.orderinfo.aggregate([
  {$match: {state: {$eq: 3}}},
  {$group: { _id: "$pay_type", total_price: {$sum: "$price"}, total_count: {$sum: 1}}},
  {$match: {total_count: {$gt: 2}}}，
  {$sort: {total_count: 1}}
])


match 在group之前相当于where
match 在group之后相当于having
############################################################################
db.orderinfo.group({
  key:{'pid':1, 'pay_type':1},
  cond: {'state':3},
  reduce: function(curr, result){
    result.price_total_count += curr.price;
    result.total_num += 1;
  },
  initial:{
    price_total_count:0,
    total_num:0
  }
})

db.orderinfo.group({
  key:{'pid':1, 'pay_type':1},
  cond: {state: {$eq:3}},
  reduce: function(curr, result){
    result.price_total_count += curr.price;
    result.total_num += 1;
  },
  initial:{
    price_total_count:0,
    total_num:0
  }
})


key 指定要分组的字段                groupby
cond 指定要查询的条件               where
reduce  param1 当前的每一行         聚合函数
        param2 结果记录所在的组

initial 组操作开始前初始化          进入组时初始化
finalize 组操作完成时回调           离开组时初始化

group 需要手写聚合函数
group 不支持shard cluster 无法分布式运算


{
  key:{cat_id:1},
  cond:{},
  reduce:dunction(curr, result){
    result.cnt += 1;
    result.sum += curr.shop_price;
  },
  initialize:{sum:0, cnt:0},
  finalize:function(result){
    result.avg = result.sum/result.cnt;
  },
}




求综合 相加
求最大 最小 比较
求平均  使用finilize 组操作完成后执行回调函数

var eval_result = eval('(' + curr['result'] + ')');
var eval_result = JSON.parse(curr['result']);


######################################################################
db.orderinfo.group({
  key:{'pid':1, 'pay_type':1},
  cond: {'state':3},
  reduce: function(curr, result){
    result.total_price += curr.price;
    result.total_count += 1;
    result.total_good_awards_num += eval(curr.good_awards)[0]['num'];
  },
  initial:{
    total_price:0,
    total_good_awards_num: 0,
    total_count:0,

  }
})

db.orderinfo.group({
  key:{'pay_type':1},
  cond: {'state':3},
  reduce: function(curr, result){
    result.total_price += curr.price;
    result.total_count += 1;
    result.total_good_awards_num += eval(curr.good_awards)[0]['num'];
  },
  initial:{
    total_price:0,
    total_good_awards_num: 0,
    total_count:0,
  }

})

#小额金币(88)赠送情况 {reasion:33 num:-88}
db.money.group({
  key:{'reasion':1},
  cond:{'reasion':33, 'num':-88},
  initial:{rid_count:{}},
  reduce:function(curr, result){
    if(curr['rid'] in result.rid_count){
      result.rid_count[curr['rid']] += 1;
    }else{
      result.rid_count[curr['rid']] = 1;
    }
  },
  finalize: function(result){

  }
})


db.tablelog.group({
  key: {'room_type': 1},
  initial: {
    total_count: 0,
    total_rid: 0,
    avg_count: 0.0,
    total_num: {},
  },
  reduce: function(curr, result){
    result.total_count += 1;
    var eval_result = eval('('+ curr['result'] +')');
    for(var i in eval_result){
      if(eval_result[i]['rid'] in result.total_num){
        result.total_num[eval_result[i]['rid']] += 1;
      } else {
        result.total_num[eval_result[i]['rid']] = 1;
      }
    }
  },
  finalize: function(reducor){
    for(var i in reducor.total_num){
      reducor.total_rid += 1;
    }
    reducor.avg_count = Math.round(reducor.total_count / reducor.total_rid)*1000/1000;
  }
})


db.tablelog.group({
  key: {'game_type':1, 'room_type':1},
  cond: {'game_type': {$eq:1}},
  initial: {'total_win_chips': 0},
  reduce: function(curr, result){
    var eval_result = eval('('+ curr['result'] +')');
    for(var i in eval_result){
      if(eval_result[i]['win_chips'] > 0){
        result.total_win_chips += eval_result[i]['win_chips'];
      }
    }
  }
})



db.tablelog.find({"room_type":4, "game_type":1}).limit(10).forEach(
  function(a){
    var result = eval('(' + a['result'] + ')');
    var time_stamp = a['time_stamp'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    for(var i in result){
      var tmp = "rid: " + result[i]['rid'] + " chips: " + result[i]['chips'] + " win_chips: " + result[i]['win_chips'] + " time_stamp: " + time_stamp + " rolename: " + result[i]['rolename'];
      printjson(tmp);
    }
    printjson('');
  });

#################################################
CREATE TABLE `jz_orderinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增长id',
  `pid` varchar(255) NOT NULL COMMENT '字符金额',
  `pay_type` int(11) NOT NULL COMMENT '支付渠道类型',
  `total_good_awards_num` int(11) NOT NULL COMMENT 'awards总数',
  `total_price` int(11) NOT NULL COMMENT '总金额',
  `total_count` int(11) unsigned NOT NULL COMMENT '总次数',
  `date` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `jz_orderinfo_paytype` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `pay_type` int(11) NOT NULL COMMENT '支付渠道类型',
  `total_good_awards_num` int(11) NOT NULL COMMENT '当天awards总数',
  `total_price` int(11) NOT NULL COMMENT '当天金额总数',
  `total_count` int(11) NOT NULL COMMENT '当天总次数',
  `date` int(11) NOT NULL COMMENT '时间戳',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8



db.orders.mapReduce(
  function() { emit(this.cust_id, this.amount);},         <--------map      2
  function(key, values) { return Array.sum(values)},      <--------reduce   3
  {
    query: {status: 'A'},                                 <--------query    1
    out: 'order_total'                                    <--------output   4
  }
)

MongoDB 时间戳转换
db.orderinfo.find({state: {$eq: 3}}, {'_id':0}).forEach(
  function(a){
    a['create_time'] = (new Date(a['create_time']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    a['time_stamp'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    printjson(a)
  })

db.money.find({'rid':2102011}, {'_id':0}).forEach(
  function(a){
  a['time_stamp'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
  printjson(a)
  }
)

db.tablelog.find({"game_type":1, "room_type":2, "time_stamp": {$gt: 1476010800 , $lt: 1476014400}}, {'_id':0}).forEach(
  function(a){
    a['time_stamp'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    a['result'] = eval('(' + a['result'] + ')');
    for(var i in a['result']){
      if(a['result'][i]['rid'] == 2051549){
        printjson(a);
      }
    }
  }
)

db.tablelog.find({"game_type":1}, {'_id':0, 'result':1, 'time_stamp':1}).forEach(
  function(a){
    a['time_stamp'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    a['result'] = eval('(' + a['result'] + ')');
    for(var i in a['result']){
      if(a['result'][i]['rid'] == 2030778){
        printjson(a);
      }
    }
  }
)

db.tablelog.find({"game_type":1, "room_type":2}, {'_id':0, 'result':1, 'time_stamp':1}).forEach(
  function(a){
    a['time_stamp'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    a['result'] = eval('(' + a['result'] + ')');
    for(var i in a['result']){
      if(a['result'][i]['rid'] == 2139228){
        printjson(a);
      }
    }
  }
)

use 2017_06_11
var x = {};
var y = [];
db.playerslogin.find({'isreg':0, 'channel':11},{'_id':0, 'rid':1}).forEach(
  function(a){
    if(a['rid'] in x){
      x[a['rid']] += 1;
    }else{
      x[a['rid']] = 1;
      y.push(a['rid']);
    }
  }
)



#####################################################

db.friendsngtablecreatelog.aggregate([
  {$group:{_id: "$player_num",total_signup_cost: {$sum: "$signup_cost"}, total_count: {$sum: 1}}}
])




db.friendsngtablecreatelog.group({
  key:{'player_num': 1, 'room_type': 1},
  initial:{
    total_count: 0,
    total_signup_cost: 0,
  },
  reduce: function(curr, result){
    result.total_count += 1;
    result.total_signup_cost += curr.player_num * curr.signup_cost;
  }
})

db.tablecreatelog.group({
  key: {'room_type':1},
  initial: {
    total_count: 0,
  },
  reduce: function(curr, result){
    result.total_count += 1;
  }
})
db.tablecreatelog.count()


db.createmttlog.find({"match_template_id": {"$gte": 100000}}).count()
db.createmttlog.find({"match_template_id": {"$lt": 100000}}).count()
db.createmttlog.count()


唯一性索引 插入产品文档时候要使用安全模式
多对多
每个产品属于多个分类
每个分类又能包含多个产品

\



###########################
db.playersignup.find({"match_name" : "SPT高级赛"}, {'_id':0, 'match_template_id':1})

db.matchtablelog.find({'match_template_id':322}).count();

db.playersignup.group({
  key: {match_template_id:1},
  cond: {"match_name" : "SPT高级赛"},
  initial: {count: 0,},
  reduce:function(curr, result){
    result.count += 1;
  },
})

for i in range(1,82)[::-1]:
  dbname = (datetime.datetime.now() - datetime.timedelta(days=i)).strftime("%Y_%m_%d")
  dtime = (datetime.datetime.now() - datetime.timedelta(days=i)).strftime("%Y-%m-%d")
  weekday = (datetime.datetime.now() - datetime.timedelta(days=i)).strftime("%w")
  if weekday in ['1', '4']:
    print dtime, weekday

db.money.group({
  key: {reasion:1},
  cond: {"rid" : 2120440},
  initial: {num_charge: 0, num_inc: 0, num_dec:0, count:0},
  reduce: function(curr, result){
    if(result.reasion == 1){
      result.num_charge += curr.num;
      result.count += 1;
    }else{
      result.count += 1;
      if(curr.num > 0){
        result.num_inc += curr.num;
      }else{
        result.num_dec += curr.num;
      }
    }
  }
})

db.money.group({
  key:{'reasion':1},
  cond: {"rid" : 2120440},
  initial:{'rid_info':{}},
  reduce: function(curr, result){
    if(result.rid_info[curr.rid]){
      result.rid_info[curr.rid]['count'] += 1;
      result.rid_info[curr.rid]['num'] += curr.num;
    }else{
      result.rid_info[curr.rid] = {'count':1, 'num': curr.num};
    }
  }
})

db.money.find({"rid" : 2136882}, {'_id':0});

scorenum:1, sngnum:1, mttnum:1, friendnum:1, changescorenum:1

db.playersonline.group({
  key: {rid:1},
  cond: {"rid" : 2136882},
  initial: {score_num: 0, sng_num: 0, mtt_num:0, friend_num:0, change_num:0},
  reduce: function(curr, result){
    result.score_num += curr.scorenum;
    result.sng_num += curr.sngnum,
    result.mtt_num += curr.mttnum;
    result.friend_num += curr.friendnum;
    result.change_num += curr.changescorenum;
  }
})

db.playersonline.group({
  key: {rid:1, friendnum:1},
  cond: {"friendnum": {"$gt": 0}},
  initial: {score_num: 0, sng_num: 0, mtt_num:0, friend_num:0, change_num:0},
  reduce: function(curr, result){
    result.score_num += curr.scorenum;
    result.sng_num += curr.sngnum,
    result.mtt_num += curr.mttnum;
    result.friend_num += curr.friendnum;
    result.change_num += curr.changescorenum;
  }
})

db.playersonline.aggregate([
  {"$match": {'friendnum': {'$gt': 0} } },
  {"$project": {"_id": 0, 'rid': 1, 'friendnum': 1} },
  {"$group": {"_id": "$rid", 't_num': {"$sum": "$friendnum"}, 't_rid': {"$sum": 1}} },
  {"$group": {"_id": 'null', "total_num": {"$sum": "$t_num"}, "total_rid": {"$sum": 1} } }
])

db.playersonline.find({'rid': 2188671}, {'_id':0}).forEach(
  function(a){
    a['time_stamp'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    a['onlinetime'] = (new Date(a['onlinetime']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    a['offtime'] = (new Date(a['offtime']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    printjson(a);
  })



db.tablelog.group({
  key:{'game_type': 1},
  cond:{'room_type': 2},
  initial:{'total_num': {}, 'total_rid':0},

  reduce:function(curr, result){
    var eval_result = eval('(' + curr['result'] + ')');
    for(var i in eval_result){
      if(eval_result[i]['rid'] in result.total_num){
        result.total_num[eval_result[i]['rid']] += 1;
      } else {
        result.total_num[eval_result[i]['rid']] = 1;
      }
    }
  },

  finalize: function(reducor){
    for(var i in reducor.total_num){
      reducor.total_rid += 1;
    }
  }
})

#######################
select role_money.rid, role_money.chips, role_money.update_time, role_info.rolename from role_money left join role_info on role_info.rid = role_money.rid order by role_money.chips desc limit 100;
#######################


db.playersignup.group({
    key: {"match_instance_id": 1,
      "match_start_time": 1,
      "match_template_id":1,
      "match_name": 1
    },
    cond: {
      "match_name": {"$in": ["博鳌SPT中级赛",]}
    },
    initial: {'sign_count': 0, 'rid_list':{}},
    reduce: function(curr, result){
      result.sign_count += 1;
      if(curr.rid in result.rid_list){
        result.rid_list[curr.rid] += 1;
      }else{
        result.rid_list[curr.rid] = 1;
      }
    }
  })

db.createmttlog.group({
  key: {"match_instance_id": 1,
      "match_start_time": 1,
      "match_template_id":1,
      "match_name": 1},
  cond: {"match_template_id": {"$gte": 100000}},
  initial: {"count": 0},
  reduce: function(curr, result){
    result.count += 1;
  }
})

db.tablelog.group

db.tablelog.group({
  key: {"room_type":1, "game_type":1},
  cond: {'room_type': {'$in': [1, 2]}},
  initial: {rid_lists: {}, "t1":0, "t2":0, "t3":0, "t4":0},
  reduce: function(curr, result){
    var eval_result = eval('(' + curr['result'] + ')');
    var robots = [2136484,2128939,2178829,2017546,2066227,2182515,2182709,2087834,2017970,2083044,2033658,2054724,2172671,2031179,2198741,2196242,2018119,2137329,2147366,2081594,2154823,2037640,2146736,2129340,2179008,2041108,2108168,2016654,2067597,2086895,2115512,2182729,2068801,2047632,2089226,2023739,2182471,2121120,2007468,2007269,2127524,2077956,2200345,2002502,2115815,2196677,2031910,2037688,2189654,2016338,2110442,2177620,2107763,2101722,2120399,2093874,2005084,2107861,2056984,2063107,2109820,2147801,2002380,2170308,2148751,2163204,2112958,2184792,2129574,2157738,2156617,2043694,2102445,2017475,2103225,2087942,2109504,2107507,2072241,2191733,2040404,2015238,2091513,2130100,2173157,2030254,2088249,2106501,2118737,2013145,2053996,2059960,2123989,2102101,2148618,2116370,2073012,2001250,2041840,2010017,2127528,2017123,2021024,2047419,2168730,2088254,2077789,2027498,2044780,2170937,2193958,2160788,2090432,2065001,2137939,2019292,2015770,2136496,2141106,2042609,2163810,2104978,2018108,2168972,2023597,2042801,2131573,2047417,2132199,2014440,2053231,2066866,2048214,2065251,2040070,2017428,2048785,2116729,2114673,2081545,2039447,2022942,2179318,2169936,2106037,2158339,2183707,2142919,2119446,2176448,2077415,2123843,2197359,2142024,2017712,2177856,2184061,2020885,2141335,2143317,2006485,2090515,2021388,2123676,2014132,2183663,2067922,2160629,2119890,2071877,2002467,2186858,2113235,2136557,2081044,2168607,2155175,2145702,2081254,2151366,2088826,2083145,2051156,2025680,2124620,2096303,2126763,2175819,2138273,2014109,218698,2016818,2188809,2092918,2047200,2076155,2024660,2171933,2032255,2140296];
    var tmp_robots = {};
    var tmp_rids = '';

    for(var i in eval_result){
      if(robots.indexOf(eval_result[i]['rid']) != -1 && eval_result[i]['win_chips'] < 0){
        result.t1 += 1;
        tmp_robots[eval_result[i]['rid']] = eval_result[i]['win_chips'];
      }else if(robots.indexOf(eval_result[i]['rid']) == -1 && eval_result[i]['win_chips'] > 0 ){
        result.t2 += 1;
        tmp_rids = eval_result[i]['rid'];
      }
    }

    if( tmp_rids && JSON.stringify(tmp_robots) != '{}'){
      var robot_val = 0;
      for(var i in tmp_robots){
        result.t3 += 1;
        robot_val += tmp_robots[i];
      }

      if(tmp_rids in result.rid_lists){
        result.rid_lists[tmp_rids] += -robot_val;
      } else {
        result.t4 += 1;
        result.rid_lists[tmp_rids] = -robot_val;
      }
    }
  }

})


sorted(x.items(), lambda x, y: x[1] - y[1], reverse=True)
select role_orderinfo.rid, role_info.rolename as rolename, sum(role_orderinfo.price)/100 as price_sum from role_orderinfo left join role_info on role_orderinfo.rid = role_info.rid where role_orderinfo.update_time >= '2016-10-28 00:00:00' and role_orderinfo.update_time <= '2016-10-28 23:59:59' and state = 3 group by role_orderinfo.rid order by price_sum desc limit 50;

 select role_orderinfo.rid, role_info.rolename as rolename, sum(role_orderinfo.price)/100 as price_sum from role_orderinfo left join role_info on role_orderinfo.rid = role_info.rid where role_orderinfo.state = 3 group by role_orderinfo.rid order by price_sum desc limit 30;

select count(uid), date_format(FROM_UNIXTIME( `createtime`),'%Y-%m-%d') as datetime from user where date_format(FROM_UNIXTIME( `createtime`),'%Y-%m-%d')>='2016-10-14' and date_format(FROM_UNIXTIME( `createtime`),'%Y-%m-%d')<='2016-10-24' group by datetime;

select pid, pay_type, sum(price) as total_price, count(price) as total_count,
good_awards, DATE_FORMAT(`update_time`,'%Y-%m-%d') as datetime
from role_orderinfo
where state=3 and update_time<'2016-10-29'
group by pid,pay_type,good_awards,datetime
order by datetime;

select sum(price), count(price), pid, pay_type,good_awards,DATE_FORMAT(`update_time`,'%Y-%m-%d') as datetime
from role_orderinfo
where state=3 and DATE_FORMAT(`update_time`,'%Y-%m-%d')='2016-10-28'
group by pid,pay_type,good_awards;

CREATE TABLE `jz_tmp_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rid` int(11) DEFAULT NULL,
  `room_type` int(11) DEFAULT NULL,
  `game_counts` int(11) DEFAULT NULL,
  `datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8


#每小时新登录人数统计
db.playerslogin.group({
  keyf: function(curr){
    var date = new Date(curr.time_stamp*1000);
    Y = date.getFullYear() + '-';
    M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
    D = date.getDate() + ' ';
    h = date.getHours();
    var dateKey = Y + M + D + h;
    return {'date': dateKey};
  },
  initial: {count:0, rid_lists: {}},
  reduce: function(curr, result){
    if(curr.rid in result.rid_lists){
      result.rid_lists[curr.rid] += 1;
    }else{
      result.rid_lists[curr.rid] = 1;
    }
  },
  finalize: function(reducor){
    for(var i in reducor.rid_lists){
      reducor.count += 1;
    }
    delete reducor.rid_lists;
  }

})


db.tablelog.find({'game_type':1,
  'room_type':7,
  'time_stamp':{"$gte":1482548400, "$lte":1482595200}
}).forEach(
  function(a){
    a['result']=eval('('+ a['result'] +')');
    a['时间'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    for(var i in a['result']){
      if(a['result'][i]['rid'] == 2031634){
        printjson(a);
      }
    }
  })

db.tablelog.find({'game_type':1,
  'room_type':7,
}).forEach(
  function(a){
    a['result']=eval('('+ a['result'] +')');
    a['时间'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    for(var i in a['result']){
      if(a['result'][i]['rid'] == 2256158){
        printjson(a);
      }
    }
  })

db.playerslogin.find({"isreg" : 0}, {'_id':0, 'rid':1, "isreg":1, 'time_stamp':1}).forEach(
  function(a){
    a['时间'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    printjson(a);
  })


var count = 0
db.matchtablelog.find({'time_stamp':{"$gte":1477584000, "$lte":1477587600}}).forEach(
  function(a){
    a['result']=eval('('+ a['result'] +')');
    for(var i in a['result']){
      if(a['result'][i]['rid'] == 2154395){
        count = count + 1;
        printjson(a['result'][i]);
      }
    }
  })

db.tablesrecord.find({"match_instance_id" : "matchsvr_114775453731611477545373090.0"}).forEach(
  function(a){
    a['player_list'] = eval('('+ a['player_list'] +')');
    for(var i in a['player_list']){
      if(a['player_list'][i]['rid'] == 2154395){
        printjson(a['player_list'][i]);
      }
    }
  })

db.money.find({'rid': 2256158, 'reasion': {"$in": [15, 16, 8, 44, 45, 35, 50, 51, 52, 53, 54, 55, 61] }}, {'_id':0}).forEach(
  function(a){
    a['时间'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    printjson(a);
  })


db.tablelog.group({
  key: {"room_type":1, "game_type":1},
  cond: {'room_type': {'$in':[1,2,3,7,8]}},
  initial: {'robot_count':0, 'user_count':0,
   'total_count':0, 'summary':{}, 'win_chips':0},
  reduce: function(curr, result){
    var eval_result = eval('(' + curr['result'] + ')');
    var robots = [2136484,2128939,2178829,2017546,2066227,2182515,2182709,2087834,2017970,2083044,2033658,2054724,2172671,2031179,2198741,2196242,2018119,2137329,2147366,2081594,2154823,2037640,2146736,2129340,2179008,2041108,2108168,2016654,2067597,2086895,2115512,2182729,2068801,2047632,2089226,2023739,2182471,2121120,2007468,2007269,2127524,2077956,2200345,2002502,2115815,2196677,2031910,2037688,2189654,2016338,2110442,2177620,2107763,2101722,2120399,2093874,2005084,2107861,2056984,2063107,2109820,2147801,2002380,2170308,2148751,2163204,2112958,2184792,2129574,2157738,2156617,2043694,2102445,2017475,2103225,2087942,2109504,2107507,2072241,2191733,2040404,2015238,2091513,2130100,2173157,2030254,2088249,2106501,2118737,2013145,2053996,2059960,2123989,2102101,2148618,2116370,2073012,2001250,2041840,2010017,2127528,2017123,2021024,2047419,2168730,2088254,2077789,2027498,2044780,2170937,2193958,2160788,2090432,2065001,2137939,2019292,2015770,2136496,2141106,2042609,2163810,2104978,2018108,2168972,2023597,2042801,2131573,2047417,2132199,2014440,2053231,2066866,2048214,2065251,2040070,2017428,2048785,2116729,2114673,2081545,2039447,2022942,2179318,2169936,2106037,2158339,2183707,2142919,2119446,2176448,2077415,2123843,2197359,2142024,2017712,2177856,2184061,2020885,2141335,2143317,2006485,2090515,2021388,2123676,2014132,2183663,2067922,2160629,2119890,2071877,2002467,2186858,2113235,2136557,2081044,2168607,2155175,2145702,2081254,2151366,2088826,2083145,2051156,2025680,2124620,2096303,2126763,2175819,2138273,2014109,218698,2016818,2188809,2092918,2047200,2076155,2024660,2171933,2032255,2140296];

    for(var i in eval_result){
      result.total_count += 1;
      if(robots.indexOf(eval_result[i]['rid']) != -1){
        result.robot_count += 1;
      }else{
        result.user_count += 1;
      }
    }
  }
})

cond: {'room_type': {'$in':[1,2,3,7,8]}},
#德州游戏场机器人玩牌局数  和 赢取金币数量
db.tablelog.group({
  key: {"room_type":1, "game_type":1},
  initial: {'robot_count':0, 'win_chips':0, 'lose_chips':0, 'finall_chips':0},
  reduce: function(curr, result){
    var eval_result = eval('(' + curr['result'] + ')');
    var robots = [2136484,2128939,2178829,2017546,2066227,2182515,2182709,2087834,2017970,2083044,2033658,2054724,2172671,2031179,2198741,2196242,2018119,2137329,2147366,2081594,2154823,2037640,2146736,2129340,2179008,2041108,2108168,2016654,2067597,2086895,2115512,2182729,2068801,2047632,2089226,2023739,2182471,2121120,2007468,2007269,2127524,2077956,2200345,2002502,2115815,2196677,2031910,2037688,2189654,2016338,2110442,2177620,2107763,2101722,2120399,2093874,2005084,2107861,2056984,2063107,2109820,2147801,2002380,2170308,2148751,2163204,2112958,2184792,2129574,2157738,2156617,2043694,2102445,2017475,2103225,2087942,2109504,2107507,2072241,2191733,2040404,2015238,2091513,2130100,2173157,2030254,2088249,2106501,2118737,2013145,2053996,2059960,2123989,2102101,2148618,2116370,2073012,2001250,2041840,2010017,2127528,2017123,2021024,2047419,2168730,2088254,2077789,2027498,2044780,2170937,2193958,2160788,2090432,2065001,2137939,2019292,2015770,2136496,2141106,2042609,2163810,2104978,2018108,2168972,2023597,2042801,2131573,2047417,2132199,2014440,2053231,2066866,2048214,2065251,2040070,2017428,2048785,2116729,2114673,2081545,2039447,2022942,2179318,2169936,2106037,2158339,2183707,2142919,2119446,2176448,2077415,2123843,2197359,2142024,2017712,2177856,2184061,2020885,2141335,2143317,2006485,2090515,2021388,2123676,2014132,2183663,2067922,2160629,2119890,2071877,2002467,2186858,2113235,2136557,2081044,2168607,2155175,2145702,2081254,2151366,2088826,2083145,2051156,2025680,2124620,2096303,2126763,2175819,2138273,2014109,218698,2016818,2188809,2092918,2047200,2076155,2024660,2171933,2032255,2140296];
    var rob = 0;
    for(var i in eval_result){
      if(robots.indexOf(eval_result[i]['rid']) != -1){
        rob = 1;
        var chips = eval_result[i]['win_chips'];
        result.finall_chips += chips;
        if(chips > 0){
          result.win_chips += chips;
        }else{
          result.lose_chips += chips;
        }
      }
    }
    if(rob == 1){
      result.robot_count += 1;
    }
  }
})

#德州金币变化reasion分组
db.money.group({
  key:{'reasion':1},
  crond: {'reasion': {'$in':[1,2,3]}},
  initial: {'total_robot_num':0, 'total_normal_num':0},
  reduce: function(curr, result){
    var robots = [2136484,2128939,2178829,2017546,2066227,2182515,2182709,2087834,2017970,2083044,2033658,2054724,2172671,2031179,2198741,2196242,2018119,2137329,2147366,2081594,2154823,2037640,2146736,2129340,2179008,2041108,2108168,2016654,2067597,2086895,2115512,2182729,2068801,2047632,2089226,2023739,2182471,2121120,2007468,2007269,2127524,2077956,2200345,2002502,2115815,2196677,2031910,2037688,2189654,2016338,2110442,2177620,2107763,2101722,2120399,2093874,2005084,2107861,2056984,2063107,2109820,2147801,2002380,2170308,2148751,2163204,2112958,2184792,2129574,2157738,2156617,2043694,2102445,2017475,2103225,2087942,2109504,2107507,2072241,2191733,2040404,2015238,2091513,2130100,2173157,2030254,2088249,2106501,2118737,2013145,2053996,2059960,2123989,2102101,2148618,2116370,2073012,2001250,2041840,2010017,2127528,2017123,2021024,2047419,2168730,2088254,2077789,2027498,2044780,2170937,2193958,2160788,2090432,2065001,2137939,2019292,2015770,2136496,2141106,2042609,2163810,2104978,2018108,2168972,2023597,2042801,2131573,2047417,2132199,2014440,2053231,2066866,2048214,2065251,2040070,2017428,2048785,2116729,2114673,2081545,2039447,2022942,2179318,2169936,2106037,2158339,2183707,2142919,2119446,2176448,2077415,2123843,2197359,2142024,2017712,2177856,2184061,2020885,2141335,2143317,2006485,2090515,2021388,2123676,2014132,2183663,2067922,2160629,2119890,2071877,2002467,2186858,2113235,2136557,2081044,2168607,2155175,2145702,2081254,2151366,2088826,2083145,2051156,2025680,2124620,2096303,2126763,2175819,2138273,2014109,218698,2016818,2188809,2092918,2047200,2076155,2024660,2171933,2032255,2140296];
    if(robots.indexOf(curr.rid) != -1){
      result.total_robot_num += curr.num;
    }else{
      result.total_normal_num += curr.num;
    }
  }
})



"room_type":1,

db.tablelog.group({
  key: { "game_type":1},
  cond: {'room_type': {'$in':[1,2,3,7]},'game_type':1,'time_stamp':{"$gte": 1480089600, "$lte": 1480175999}},
  initial: {total_num:{}},
  reduce: function(curr, result){
    var eval_result = eval('(' + curr['result'] + ')');
    var robots = [2136484,2128939,2178829,2017546,2066227,2182515,2182709,2087834,2017970,2083044,2033658,2054724,2172671,2031179,2198741,2196242,2018119,2137329,2147366,2081594,2154823,2037640,2146736,2129340,2179008,2041108,2108168,2016654,2067597,2086895,2115512,2182729,2068801,2047632,2089226,2023739,2182471,2121120,2007468,2007269,2127524,2077956,2200345,2002502,2115815,2196677,2031910,2037688,2189654,2016338,2110442,2177620,2107763,2101722,2120399,2093874,2005084,2107861,2056984,2063107,2109820,2147801,2002380,2170308,2148751,2163204,2112958,2184792,2129574,2157738,2156617,2043694,2102445,2017475,2103225,2087942,2109504,2107507,2072241,2191733,2040404,2015238,2091513,2130100,2173157,2030254,2088249,2106501,2118737,2013145,2053996,2059960,2123989,2102101,2148618,2116370,2073012,2001250,2041840,2010017,2127528,2017123,2021024,2047419,2168730,2088254,2077789,2027498,2044780,2170937,2193958,2160788,2090432,2065001,2137939,2019292,2015770,2136496,2141106,2042609,2163810,2104978,2018108,2168972,2023597,2042801,2131573,2047417,2132199,2014440,2053231,2066866,2048214,2065251,2040070,2017428,2048785,2116729,2114673,2081545,2039447,2022942,2179318,2169936,2106037,2158339,2183707,2142919,2119446,2176448,2077415,2123843,2197359,2142024,2017712,2177856,2184061,2020885,2141335,2143317,2006485,2090515,2021388,2123676,2014132,2183663,2067922,2160629,2119890,2071877,2002467,2186858,2113235,2136557,2081044,2168607,2155175,2145702,2081254,2151366,2088826,2083145,2051156,2025680,2124620,2096303,2126763,2175819,2138273,2014109,218698,2016818,2188809,2092918,2047200,2076155,2024660,2171933,2032255,2140296];
    for(var i in eval_result){
      if(robots.indexOf(eval_result[i]['rid']) == -1){
        if(eval_result[i]['rid'] in result.total_num){
          result.total_num[eval_result[i]['rid']] += 1;
        } else {
          result.total_num[eval_result[i]['rid']] = 1;
        }
      }
    }
  }
})

#积分场用户手数 输赢情况
db.tablelog.aggregate([
  {
    $group:{
      _id:{
        game_type:"$game_type",
        room_type:"$room_type"
      }
    }
  }
])
db.tablelog.group({
  key:{ "game_type":1, "room_type":1},
  cond:{"game_type":1, "room_type":7},
  initial: {total_num:{}},
  reduce: function(curr, result){
    var eval_result = eval('(' + curr['result'] + ')');
    for(var i in eval_result){
      var win_status = eval_result[i]['win_chips'] > 0 ? 1 : 0;
      if(eval_result[i]['rid'] in result.total_num){
        result.total_num[eval_result[i]['rid']]['num'] += 1;
        result.total_num[eval_result[i]['rid']]['win_status'] += win_status;
        result.total_num[eval_result[i]['rid']]['win_chips'] += eval_result[i]['win_chips'];
      } else {
        result.total_num[eval_result[i]['rid']] = {'num':1,
                            'win_chips': eval_result[i]['win_chips'],
                            'rolename': eval_result[i]['rolename'],
                            'win_status': win_status};
      }
    }
  }
})



db.tablelog.group({
  key: { "game_type":1},
  cond: {'room_type': 2},
  initial: {total_num:{}},
  reduce: function(curr, result){
    var eval_result = eval('(' + curr['result'] + ')');
    var robots = [2136484,2128939,2178829,2017546,2066227,2182515,2182709,2087834,2017970,2083044,2033658,2054724,2172671,2031179,2198741,2196242,2018119,2137329,2147366,2081594,2154823,2037640,2146736,2129340,2179008,2041108,2108168,2016654,2067597,2086895,2115512,2182729,2068801,2047632,2089226,2023739,2182471,2121120,2007468,2007269,2127524,2077956,2200345,2002502,2115815,2196677,2031910,2037688,2189654,2016338,2110442,2177620,2107763,2101722,2120399,2093874,2005084,2107861,2056984,2063107,2109820,2147801,2002380,2170308,2148751,2163204,2112958,2184792,2129574,2157738,2156617,2043694,2102445,2017475,2103225,2087942,2109504,2107507,2072241,2191733,2040404,2015238,2091513,2130100,2173157,2030254,2088249,2106501,2118737,2013145,2053996,2059960,2123989,2102101,2148618,2116370,2073012,2001250,2041840,2010017,2127528,2017123,2021024,2047419,2168730,2088254,2077789,2027498,2044780,2170937,2193958,2160788,2090432,2065001,2137939,2019292,2015770,2136496,2141106,2042609,2163810,2104978,2018108,2168972,2023597,2042801,2131573,2047417,2132199,2014440,2053231,2066866,2048214,2065251,2040070,2017428,2048785,2116729,2114673,2081545,2039447,2022942,2179318,2169936,2106037,2158339,2183707,2142919,2119446,2176448,2077415,2123843,2197359,2142024,2017712,2177856,2184061,2020885,2141335,2143317,2006485,2090515,2021388,2123676,2014132,2183663,2067922,2160629,2119890,2071877,2002467,2186858,2113235,2136557,2081044,2168607,2155175,2145702,2081254,2151366,2088826,2083145,2051156,2025680,2124620,2096303,2126763,2175819,2138273,2014109,218698,2016818,2188809,2092918,2047200,2076155,2024660,2171933,2032255,2140296];
    for(var i in eval_result){
      if(robots.indexOf(eval_result[i]['rid']) == -1){
        if(eval_result[i]['rid'] in result.total_num){
          result.total_num[eval_result[i]['rid']] += 1;
        } else {
          result.total_num[eval_result[i]['rid']] = 1;
        }
      }
    }
  }
})
db.tablelog.find({"game_type":1, 'room_type': 2}, {'_id': 0, 'time_stamp':1, 'result':1}).limit(10).forEach(function(curr){
  curr['result'] = eval('(' + curr['result'] + ')');
  var time_stamp = (new Date(curr['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
  printjson('*********************************华丽的分割线***************************************************');
  printjson(time_stamp);
  var robots = [2136484,2128939,2178829,2017546,2066227,2182515,2182709,2087834,2017970,2083044,2033658,2054724,2172671,2031179,2198741,2196242,2018119,2137329,2147366,2081594,2154823,2037640,2146736,2129340,2179008,2041108,2108168,2016654,2067597,2086895,2115512,2182729,2068801,2047632,2089226,2023739,2182471,2121120,2007468,2007269,2127524,2077956,2200345,2002502,2115815,2196677,2031910,2037688,2189654,2016338,2110442,2177620,2107763,2101722,2120399,2093874,2005084,2107861,2056984,2063107,2109820,2147801,2002380,2170308,2148751,2163204,2112958,2184792,2129574,2157738,2156617,2043694,2102445,2017475,2103225,2087942,2109504,2107507,2072241,2191733,2040404,2015238,2091513,2130100,2173157,2030254,2088249,2106501,2118737,2013145,2053996,2059960,2123989,2102101,2148618,2116370,2073012,2001250,2041840,2010017,2127528,2017123,2021024,2047419,2168730,2088254,2077789,2027498,2044780,2170937,2193958,2160788,2090432,2065001,2137939,2019292,2015770,2136496,2141106,2042609,2163810,2104978,2018108,2168972,2023597,2042801,2131573,2047417,2132199,2014440,2053231,2066866,2048214,2065251,2040070,2017428,2048785,2116729,2114673,2081545,2039447,2022942,2179318,2169936,2106037,2158339,2183707,2142919,2119446,2176448,2077415,2123843,2197359,2142024,2017712,2177856,2184061,2020885,2141335,2143317,2006485,2090515,2021388,2123676,2014132,2183663,2067922,2160629,2119890,2071877,2002467,2186858,2113235,2136557,2081044,2168607,2155175,2145702,2081254,2151366,2088826,2083145,2051156,2025680,2124620,2096303,2126763,2175819,2138273,2014109,218698,2016818,2188809,2092918,2047200,2076155,2024660,2171933,2032255,2140296];
  for(var i in curr['result']){
    var summary = {};
    if(robots.indexOf(curr['result'][i]['rid']) !== -1){

      summary[curr['result'][i]['rid']] = '我是无敌机器人';
    }
    summary['rid'] = curr['result'][i]['rid'];
    summary['win_chips'] = curr['result'][i]['win_chips'];
    summary['rolename'] = curr['result'][i]['rolename'];
    printjson(summary);
  }
})

cursor = db.tablelog.find({"game_type":1, 'room_type': 2}, {'_id': 0, 'time_stamp':1, 'result':1});
while(cursor.hasNext()){
  var curr = cursor.next();
  curr['result'] = eval('(' + curr['result'] + ')');
  var time_stamp = (new Date(curr['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
  printjson('*********************************华丽的分割线***************************************************');
  printjson(time_stamp);
  var robots = [2136484,2128939,2178829,2017546,2066227,2182515,2182709,2087834,2017970,2083044,2033658,2054724,2172671,2031179,2198741,2196242,2018119,2137329,2147366,2081594,2154823,2037640,2146736,2129340,2179008,2041108,2108168,2016654,2067597,2086895,2115512,2182729,2068801,2047632,2089226,2023739,2182471,2121120,2007468,2007269,2127524,2077956,2200345,2002502,2115815,2196677,2031910,2037688,2189654,2016338,2110442,2177620,2107763,2101722,2120399,2093874,2005084,2107861,2056984,2063107,2109820,2147801,2002380,2170308,2148751,2163204,2112958,2184792,2129574,2157738,2156617,2043694,2102445,2017475,2103225,2087942,2109504,2107507,2072241,2191733,2040404,2015238,2091513,2130100,2173157,2030254,2088249,2106501,2118737,2013145,2053996,2059960,2123989,2102101,2148618,2116370,2073012,2001250,2041840,2010017,2127528,2017123,2021024,2047419,2168730,2088254,2077789,2027498,2044780,2170937,2193958,2160788,2090432,2065001,2137939,2019292,2015770,2136496,2141106,2042609,2163810,2104978,2018108,2168972,2023597,2042801,2131573,2047417,2132199,2014440,2053231,2066866,2048214,2065251,2040070,2017428,2048785,2116729,2114673,2081545,2039447,2022942,2179318,2169936,2106037,2158339,2183707,2142919,2119446,2176448,2077415,2123843,2197359,2142024,2017712,2177856,2184061,2020885,2141335,2143317,2006485,2090515,2021388,2123676,2014132,2183663,2067922,2160629,2119890,2071877,2002467,2186858,2113235,2136557,2081044,2168607,2155175,2145702,2081254,2151366,2088826,2083145,2051156,2025680,2124620,2096303,2126763,2175819,2138273,2014109,218698,2016818,2188809,2092918,2047200,2076155,2024660,2171933,2032255,2140296];
  for(var i in curr['result']){
    var summary = {};
    if(robots.indexOf(curr['result'][i]['rid']) !== -1){

      summary[curr['result'][i]['rid']] = '我是无敌机器人';
    }

    printjsosummary['rid'] = curr['result'][i]['rid'];
    summary['win_chips'] = curr['result'][i]['win_chips'];
    summary['rolename'] = curr['result'][i]['rolename'];n(summary);
  }
}

if(robots.indexOf(eval_result[i]['rid']) != -1){
        result.robot_count += 1;
      }else{
        result.user_count += 1;
      }

var robots = [2136484,2128939,2178829,2017546,2066227,2182515,2182709,2087834,2017970,2083044,2033658,2054724,2172671,2031179,2198741,2196242,2018119,2137329,2147366,2081594,2154823,2037640,2146736,2129340,2179008,2041108,2108168,2016654,2067597,2086895,2115512,2182729,2068801,2047632,2089226,2023739,2182471,2121120,2007468,2007269,2127524,2077956,2200345,2002502,2115815,2196677,2031910,2037688,2189654,2016338,2110442,2177620,2107763,2101722,2120399,2093874,2005084,2107861,2056984,2063107,2109820,2147801,2002380,2170308,2148751,2163204,2112958,2184792,2129574,2157738,2156617,2043694,2102445,2017475,2103225,2087942,2109504,2107507,2072241,2191733,2040404,2015238,2091513,2130100,2173157,2030254,2088249,2106501,2118737,2013145,2053996,2059960,2123989,2102101,2148618,2116370,2073012,2001250,2041840,2010017,2127528,2017123,2021024,2047419,2168730,2088254,2077789,2027498,2044780,2170937,2193958,2160788,2090432,2065001,2137939,2019292,2015770,2136496,2141106,2042609,2163810,2104978,2018108,2168972,2023597,2042801,2131573,2047417,2132199,2014440,2053231,2066866,2048214,2065251,2040070,2017428,2048785,2116729,2114673,2081545,2039447,2022942,2179318,2169936,2106037,2158339,2183707,2142919,2119446,2176448,2077415,2123843,2197359,2142024,2017712,2177856,2184061,2020885,2141335,2143317,2006485,2090515,2021388,2123676,2014132,2183663,2067922,2160629,2119890,2071877,2002467,2186858,2113235,2136557,2081044,2168607,2155175,2145702,2081254,2151366,2088826,2083145,2051156,2025680,2124620,2096303,2126763,2175819,2138273,2014109,218698,2016818,2188809,2092918,2047200,2076155,2024660,2171933,2032255,2140296];


红黑赛
db.redbtabaleinfolog.group({
  key: {"now_cardtype" : 1},
  initial:{'total_count':0, 'time':0,},
  reduce: function(curr, result){
    result.total_count += 1;
    if (curr.now_cardtype == 2 || curr.now_cardtype == 3 || curr.now_cardtype == 4){
      result.time += 34;
    }else{
      result.time += 34;
    }
  }
})

db.money.group({
  key:{'rid':1},
  cond: {'reasion':41},
  initial:{'jianshao_num':0, 'zengjia_num':0},
  reduce: function(curr, result){
    if (curr.num < 0){
      result.jianshao_num += curr.num;
    }else{
      result.zengjia_num += curr.num;
    }
  }
})

db.match_result.group({
  key:{'match_instance_id':1,
    'match_name':1,
    'match_start_time':1,
    'match_template_id':1},
  initial:{'total_time':0,
    'awards_dict':{},
    'reward_awards_dict':{},
    'reason_dict':{}},
  reduce: function(curr, result){
    result.total_time += curr.competitiontime;
    if(curr.awards.replace(/(^\s*)|(\s*$)/g, '').length > 2){
      if(curr.rid in result.awards_dict){
        result.awards_dict[curr.rid] += '#'+curr.awards;
      }else{
        result.awards_dict[curr.rid] = curr.awards;
      }
    }
    if(curr.reward_awards.replace(/(^\s*)|(\s*$)/g, '').length > 2){
      if(curr.rid in result.reward_awards_dict){
        result.reward_awards_dict[curr.rid] += '#'+curr.awards;
      }else{
        result.reward_awards_dict[curr.rid] = curr.awards;
      }
    }
    if(curr.reason in result.reason_dict){
      result.reason_dict[curr.reason] += 1;
    }else{
      result.reason_dict[curr.reason] = 1;
    }
  }
})


db.match_result.group({
  key:{'match_instance_id':1,
    'match_name':1,
    'match_start_time':1,
    'match_template_id':1},

  initial:{'total_time':0,
    'rid_count': 0,
    'awards_dict':{},
    'reward_awards_dict':{},
    'reason_dict':{}},
  reduce: function(curr, result){
    result.total_time += curr.competitiontime;
    result.rid_count += 1;
    if(curr.awards.replace(/(^\s*)|(\s*$)/g, '').length > 2){
      result.awards_dict[curr.rid] = eval('(' + curr['awards'] + ')');
    }
    if(curr.reward_awards.replace(/(^\s*)|(\s*$)/g, '').length > 2){
      result.reward_awards_dict[curr.rid] = eval('(' + curr['reward_awards'] + ')');
    }
    if(curr.reason in result.reason_dict){
      result.reason_dict[curr.reason] += 1;
    }else{
      result.reason_dict[curr.reason] = 1;
    }
  }
})


db.playersignup.group({
  key: {'match_instance_id':1,
    'condition':1,
    'match_template_id':1,
    'match_start_time':1,
    'match_name':1},
  cond: {'match_instance_id':　'matchsvr_18201480079009610.0'},
  initial: {'rid_list': {}},
  reduce: function(curr, result){
    if(curr.rid in result.rid_list){
      if(curr.is_signup == 0){
        result.rid_list[curr.rid] += -1;
      }else{
        result.rid_list[curr.rid] += 1;
      }
    }else{
      if(curr.is_signup == 0){
        result.rid_list[curr.rid] = -1;
      }else{
        result.rid_list[curr.rid] = curr.is_signup;
      }
    }
  },
  finalize: function(reducor){
    for(var i in reducor.rid_list){
      if(reducor.rid_list[i] == 0){
        delete reducor.rid_list[i];
      }
    }
  }
})

#mtt比赛结果信息
db.tablesrecord.aggregate([
  {
    $match : {
      match_instance_id: {'$exists': true},
    }
  },
  {
    $group: {
      _id: {
        match_start_time: '$match_start_time',
        match_instance_id: '$match_instance_id',
        match_signup_num: '$match_signup_num',
        total_signup_chips:'$total_signup_chips',
        rebuy_count:'$rebuy_count',
        addbuy_count:'$addbuy_count',
        player_list: '$player_list'
      }
    }
  }
]).forEach(function(a){
    x = a['_id'];
    if(x != {}){
      x['start_datetime']=(new Date(x['match_start_time']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
      printjson(x);
    }
  })

#mtt比赛报名信息
db.playersignup.aggregate([
  {
    $match: {
      match_template_id: {'$lte': 100000},
    }
  },
  {
    $group: {
      _id: {
        match_name: "$match_name",
        match_start_time: "$match_start_time",
        match_instance_id: '$match_instance_id'
      }
    }
  }
]).forEach(function(a){
  x = a['_id'];
  x['start_datetime']=(new Date(x['match_start_time']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
  printjson(x);
})

#mtt比赛创建信息
db.createmttlog.aggregate([
  {
    $match: {
      match_template_id: {'$lte': 100000},
    }
  },
  {
    $group: {
      _id: {
        match_name: "$match_name",
        match_start_time: "$match_start_time",
        match_instance_id: '$match_instance_id',
        time_stamp: '$time_stamp',
      },
      t: {$last: '$time_stamp'},
    }
  },
  {
    $sort: {
      t:1,
    }
  }
]).forEach(function(a){
  x = a['_id'];
  x['start_datetime']=(new Date(x['match_start_time']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
  x['更新后时间']=(new Date(a['t']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
  printjson(x);
})


db.tablelog.aggregate([
  {
    $match:{
      room_type:4,
    }
  },
  {
    $group:{
      _id:{
        create_rid: "$create_rid",
        identify_code: "$identify_code",
      }
    }
  }
])
db.tablelog.group({
  key: {'create_rid':1},
  crond: {'room_type':4},
  initial: {code:0},
  reduce: function(curr, res){

  }
})

select * from role_signupinfo  limit 100 \G

#高级比赛开赛情况
 select jz_cmttlog.match_name, jz_cmttlog.match_start_pretty_time ,
  jz_trecord.match_signup_num , jz_trecord.rebuy_count ,
  jz_trecord.addbuy_count, jz_trecord.match_instance_id
  from jz_trecord left join jz_cmttlog
  on jz_cmttlog.match_instance_id = jz_trecord.match_instance_id
  where jz_cmttlog.match_name  = '老虎杯高级赛'
  order by match_start_pretty_time;

show VARIABLES like '%max_allowed_packet%';
set global max_allowed_packet = 2*1024*1024*10
max_allowed_packet = 20M


select platform.user.uid, texasgame.role_auth.rid
from platform.user left join texasgame.role_auth
on platform.user.uid = texasgame.role_auth.uid
where platform.user.regfrom = 100043;


select rid, count(rid) as total_count, sum(price) as total_price from role_orderinfo where state = 3 and update_time >= '2016-11-21' and update_time <= '2016-12-01' group by rid order by total_price;


select jz_trecord.match_instance_id, jz_cmttlog.match_name, jz_trecord.signup_fees, jz_trecord.match_start_pretty_time, jz_trecord.player_list from jz_trecord left join jz_cmttlog on jz_cmttlog.match_instance_id = jz_trecord.match_instance_id where jz_trecord.match_start_pretty_time >= '2016-11-21' and jz_trecord.match_start_pretty_time <= '2016-12-01' and jz_cmttlog.match_template_id < 100000 and jz_trecord.player_list != '{}' and jz_trecord.signup_fees != '[{"id":1,"num":0}]' limit 20 \G

#月支付类型和人数
select count(rid), count(distinct(rid)), sum(price)
from role_orderinfo
where update_time >= '2017-04-01 00:00:00'
and update_time <= '2017-04-30 23:59:59'
and state=3;

徽章前500名
select rid, sum(prop_num) as prop_count
from role_propinfo
where update_time >= '2016-12-16 00:00:00'
and config_id=2
group by rid
order by prop_count
desc limit 500;
