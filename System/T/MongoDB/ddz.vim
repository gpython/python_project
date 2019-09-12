###########################斗地主 MongoDB###############################
按照regfrom 注册来源统计 新增 用户数量
db.loginlog.group({
  key:{'regfrom':1, 'platform':1, 'channel':1,'authtype':1},
  cond:{'isreg':1},
  initial:{'rid_list': {}},
  reduce:function(curr, result){
    result.rid_list[curr.rid] = 1;
  }
})

按照regfromn注册来源 统计每天登录用户数量
db.loginlog.group({
  key:{'regfrom':1},
  initial:{'rid_list': {}},
  reduce:function(curr, result){
    result.rid_list[curr.rid] = 1;
  }
})

按照平台 渠道 统计 新增 用户信息
db.loginlog.group({
  key:{'platform':1, 'channel':1},
  cond:{'isreg':1},
  initial:{'rid_list': {}},
  reduce:function(curr, result){
    result.rid_list[curr.rid] = 1;
  }
})

按照平台 渠道统计 登录  活跃用户数
db.loginlog.group({
  key:{'platform':1, 'channel':1},
  initial:{'rid_list': {}, 'total_count':0},
  reduce:function(curr, result){
    result.rid_list[curr.rid] = 1;
  },
  finalize: function(reducor){
    for(var i in reducor.rid_list){
      reducor.total_count += 1;
    }
  }
})

不同游戏场 玩家花费时间
db.totaltimelog.aggregate([
  {
    $group:{
      _id:{room_type:"$room_type", game_type:"$game_type"},
      total_time: {$sum:"$totaltime"},
    }
  }
])

不同游戏场 玩家去重数量
db.totaltimelog.group({
  key:{'room_type':1, 'game_type':1},
  initial: {'rid_list': {}, 'total_count':0},
  reduce: function(curr, result){
    result.rid_list[curr.rid] = 1;
  },
  finalize: function(reducor){
    for(var i in reducor.rid_list){
      reducor.total_count += 1;
    }
    delete reducor.rid_list;
  }
})

#不同游戏场 局数 总时长 人数
db.totaltimelog.group({
  key:{'room_type':1, 'game_type':1},
  initial: {'total_time':{}, 'total_count':{}, 'rid_count':0},
  reduce: function(curr, result){
    if(result.total_time[curr.rid]){
      result.total_time[curr.rid] += curr.totaltime;
    }else{
      result.total_time[curr.rid] = curr.totaltime;
    }
    if(result.total_count[curr.rid]){
      result.total_count[curr.rid] += 1;
    }else{
      result.total_count[curr.rid] = 1;
    }
  },
  finalize: function(reducor){
    for(var i in reducor.total_count){
      reducor.rid_count += 1;
    }
  }
})


不同游戏场 用户总流水情况
db.zliushuilog.group({
  key:{'room_type':1, 'game_type':1},
  cond: {'win':1},
  initial: {'liushui_num':0},
  reduce: function(curr, result){
    result.liushui_num += curr.num;
  }
})

#不同游戏场 每用户 输赢场次 和 输赢金币数量
db.zliushuilog.group({
  key:{'room_type':1, 'game_type':1},
  initial: {'rid_info':{}},
  reduce:function(curr, result){
    if(result.rid_info[curr.rid]){
      if(curr.win == 1){
        result.rid_info[curr.rid]['win_count'] += 1;
      }else{
        result.rid_info[curr.rid]['lose_count'] += 1;
      }
      if(curr.num > 0){
        result.rid_info[curr.rid]['win_num'] += curr.num;
      }else{
        result.rid_info[curr.rid]['lose_num'] += curr.num;
      }
    }else{
      result.rid_info[curr.rid] = {};
      if(curr.win == 1){
        result.rid_info[curr.rid]['win_count'] = 1;
        result.rid_info[curr.rid]['lose_count'] = 0;
      }else{
        result.rid_info[curr.rid]['win_count'] = 0;
        result.rid_info[curr.rid]['lose_count'] = 1;
      }
      if(curr.num > 0){
        result.rid_info[curr.rid]['win_num'] = curr.num;
        result.rid_info[curr.rid]['lose_num'] = 0;
      }else{
        result.rid_info[curr.rid]['win_num'] = 0;
        result.rid_info[curr.rid]['lose_num'] = curr.num;
      }
    }
  }
})

#不同游戏场 副本数量
db.callectlog.group({
  key:{'room_type':1, 'game_type':1},
  initial: {'fuben_count':0},
  reduce: function(curr, result){
    result.fuben_count += 1;
  }
})

#不同游戏场 主动离开人数
db.leavelog.group({
  key:{'room_type':1, 'game_type':1},
  initial: {'leave_count':0},
  reduce: function(curr, result){
    result.leave_count += 1;
  }
})


#不同游戏场抽水情况
db.choushuilog.group({
  key:{'room_type':1, 'game_type':1},
  initial:{'choushui_count':0, 'choushui_info':{}},
  reduce:function(curr, result){
    if(result.choushui_info[curr.rid]){
      result.choushui_info[curr.rid]['num'] += curr.num;
      result.choushui_info[curr.rid]['count'] += 1;
    }else{
      result.choushui_info[curr.rid] = {'count':1, 'num':curr.num};
    }
    result.choushui_count += curr.num;
  }
})


#不同游戏场 机器人情况
db.robotlog.group({
  key:{'room_type':1, 'game_type':1},
  cond:{'robot':true},
  initial: {'robot_rid':{}, 'robot_count':0},
  reduce: function(curr, result){
    if(result.robot_rid[curr.rid]){
      result.robot_rid[curr.rid] += 1;
    }else{
      result.robot_rid[curr.rid] = 1;
    }
  },
  finalize: function(reducor){
    for(var i in reducor.robot_rid){
      reducor.robot_count += 1;
    }
  }
})

#金币变化的不同 reason 情况
db.coinlog.group({
  key:{'reason':1},
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

#主动离开的总人次 (缺少rid)
db.leavelog.group({
  key:{'room_type':1, 'game_type':1},
  initial:{'leave_count':0, 'leave_rid':{}},
  reduce: function(curr, result){
    result.leave_count += 1;
    result.leave_rid[curr.rid] = 1;
  }
})

#破产补助情况
db.bankruptinfolog.group({
  key:{'option':1},
  initial: {'bankrupt':{}},
  reduce: function(curr, result){
    if(result.bankrupt[curr.rid]){
      result.bankrupt[curr.rid]['count'] += 1;
      result.bankrupt[curr.rid]['coin'] += curr.coin;
    }else{
      result.bankrupt[curr.rid] = {'count':1, 'coin': curr.coin}
    }
  }
})

#用户最后登录时间
db.loginlog.aggregate([
  {$group:{
      _id:{rid:'$rid'},
      logintime:{'$last': '$logintime'},
      ipaddr:{'$last': '$ipaddr'},
      version:{'$last': '$version'}
    }
  }
])

#斗地主 每天道具发放情况
db.propinfolog.group({
  key:{'config_id':1, 'reason':1},
  initial: {'rid_info':{}},
  reduce: function(curr, result){
    var prop_count = curr.afterprop_num - curr.beforeprop_num;
    if(prop_count !== 0 ){
      if(result.rid_info[curr.rid]){
        result.rid_info[curr.rid]['props'] += prop_count;
      }else{
        result.rid_info[curr.rid] = {'props': prop_count};
      }
    }
  }
})

#斗地主 道具发放情况
db.propinfolog.group({
  key:{'reason':1, 'config_id':1},
  initial: {'rid_info':{}},
  reduce: function(curr, result){
    var prop_count = curr.afterprop_num - curr.beforeprop_num;
    if(prop_count !== 0 ){
      if(result.rid_info[curr.rid]){
        if(prop_count > 0){
          if(result.rid_info[curr.rid]['GET']){
            result.rid_info[curr.rid]['GET'] += prop_count;
          }else{
            result.rid_info[curr.rid]['GET'] = prop_count;
          }
        }else{
          if(result.rid_info[curr.rid]['USED']){
            result.rid_info[curr.rid]['USED'] += prop_count;
          }else{
            result.rid_info[curr.rid]['USED'] = prop_count;
          }
        }
      }else{
        result.rid_info[curr.rid] = {};
        if(prop_count > 0){
          result.rid_info[curr.rid]['GET'] = prop_count;
          result.rid_info[curr.rid]['USED'] = 0;
        }else{
          result.rid_info[curr.rid]['USED'] = prop_count;
          result.rid_info[curr.rid]['GET'] = 0;
        }
      }
    }
  }
})

#斗地主 发送邮件详情
db.orderlog.group({
  key:{'reason':1},
  initial: {'rid_info':{}},
  reduce: function(curr, result){
    var eval_result = eval('(' + curr['mailcontent'] + ')');
    var awards = eval_result['awards'];
    if(awards){
      for(var i in awards){
        if(rid_info[curr.rid])
      }
    }
  }
})

##############################斗地主 MySQL################################
充值情况 充值总额 充值总人数 充值总人次
select count(rid), count(distinct(rid)), sum(price),
  DATE_FORMAT(`update_time`,'%Y-%m-%d') as dtime
  from role_orders
  where state = 3
  group by dtime;

#首充 首次充值数 首次充值人数
select count(rid), sum(price)
  from role_orders
  where state=3
  and DATE_FORMAT(`update_time`,'%Y-%m-%d')='2017-03-31'
  and recharge_type=1;

#充值用户rid 和充值次数
select rid, count(rid) from role_orders
  where state=3
  and DATE_FORMAT(`update_time`,'%Y-%m-%d')='2017-03-31'
  group by rid;

#从库role_orders表数据拷贝到ddz
select rid, pid, pay_type, price, good_id,
  good_awards, create_time, state, channel,
  recharge_type, update_time
  from role_orders
  where state=3
  and DATE_FORMAT(`update_time`,'%Y-%m-%d')='2017-03-31';


select distinct(rid), DATE_FORMAT(`update_time`,'%Y-%m-%d') as dtime
from role_orders
where state = 3
order by dtime;

#斗地主每月充值 人数 人次 总额
select count(distinct(rid)), count(rid), sum(price)
from ddz_orders
where  state=3
and DATE_FORMAT(`update_time`,'%Y-%m') = '2017-04';

#每月活跃用户数(登录用户) 基础SQL
select isreg_0, isreg_1, update_time
from ddz_retained
where DATE_FORMAT(`update_time`,'%Y-%m') = '2017-04'
