#德州用户最后登录时间
db.loginlog.aggregate([
  {$group:{
      _id:{rid:'$rid'},
      last_time:{'$last': '$time_stamp'},
      ip:{'$last': '$ip'}
    }
  }
])

#德州 不同游戏场 每用户 输赢场次 和 输赢金币数量
db.tablelog.group({
  key: {'room_type':1, 'game_type':1},
  initial: {'rid_info':{}},
  reduce: function(curr, result){
    var eval_result = eval('(' + curr['result'] + ')');
    for(var i in eval_result){
      var rid = eval_result[i]['rid'];
      var win_chips = eval_result[i]['win_chips'];
      if(result.rid_info[rid]){
        result.rid_info[rid]['total_count'] += 1;
        if(win_chips>=0){
          result.rid_info[rid]['win_count'] += 1;
          result.rid_info[rid]['win_num'] += win_chips;
        }else{
          result.rid_info[rid]['lose_count'] += 1;
          result.rid_info[rid]['lose_num'] += win_chips;
        }
      }else{
        result.rid_info[rid] = {};
        result.rid_info[rid]['total_count'] = 1;
        if(win_chips>=0){
          result.rid_info[rid]['win_count'] = 1;
          result.rid_info[rid]['win_num'] = win_chips;
          result.rid_info[rid]['lose_count'] = 0;
          result.rid_info[rid]['lose_num'] = 0;
        }else{
          result.rid_info[rid]['win_count'] = 0;
          result.rid_info[rid]['win_num'] = 0;
          result.rid_info[rid]['lose_count'] = 1;
          result.rid_info[rid]['lose_num'] = win_chips;
        }
      }
    }
  }
})

#德州 不同游戏场总场数
db.tablelog.group({
  key: {'room_type':1, 'game_type':1},
  initial: {'total_count':0},
  reduce: function(curr, result){
    result.total_count += 1;
  }
})

db.tablelog.group({
  key: {'game_type':1},
  crond :{'room_type':3},
  initial: {'rid_count':0},
  reduce: function(curr, result){
    var eval_result = eval('(' + curr['result'] + ')');
    for(var i in eval_result){
      var rid = eval_result[i]['rid'];
      if(curr.room_type ==3 && rid == 2283044){
        result.rid_count += 1;
      }
    }
  }
})

db.jackpotchange.group({
  key: {'room_type':1, 'reason':1},
  initial: {jack_incr:0, jack_desc:0},
  reduce: function(curr, result){
    if(curr.num > 0){
      result.jack_incr += curr.num;
    }else{
      result.jack_desc += curr.num;
    }
  }
})



#德州 用户在线时长
db.playersonline.group({
  key:{'channel':1},
  initial: {rid_info:{}},
  reduce: function(curr, result){
    if(curr.onlinetime !== 0 && curr.offtime !== 0){
      var l_time = curr.offtime - curr.onlinetime;
    }else{
      var l_time = 0;
    }
    if(result.rid_info[curr.rid]){
      result.rid_info[curr.rid]['l_time'] += l_time;
      result.rid_info[curr.rid]['login_count'] += 1;
      result.rid_info[curr.rid]['sngnum'] += curr.sngnum;
      result.rid_info[curr.rid]['changescorenum'] += curr.changescorenum;
      result.rid_info[curr.rid]['scorenum'] += curr.scorenum;
      result.rid_info[curr.rid]['friendnum'] += curr.friendnum;
      result.rid_info[curr.rid]['mttnum'] += curr.mttnum;
    }else{
      result.rid_info[curr.rid] = {
        'l_time': l_time,
        'login_count' : 1,
        'sngnum':curr.sngnum,
        'changescorenum': curr.changescorenum,
        'scorenum': curr.scorenum,
        'friendnum': curr.friendnum,
        'mttnum': curr.mttnum
      }
    }
  }
})

#德州 道具获取
db.props.group({
  key:{'config_id':1, 'reasion':1},
  cond: {'reasion': 41},
  initial: {'rid_info':{}, 'props_count':0},
  reduce: function(curr, result){
    var prop_count = curr.afterprop_num - curr.beforeprop_num;
    if(prop_count !== 0 ){
      if(result.rid_info[curr.rid]){
        result.rid_info[curr.rid]['props'] += prop_count;
      }else{
        result.rid_info[curr.rid] = {'props': prop_count};
      }
    }
  },
  finalize: function(reducor){
    for(var i in reducor.rid_info){
      reducor.props_count += reducor.rid_info[i]['props'];
    }
    delete reducor.rid_info;
  }
})

db.tablelog.find({'room_type':3}).forEach(
  function(a){
    a['time_stamp'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    var eval_result = eval('(' + a['result'] + ')');
    for(var i in eval_result){
      if(eval_result[i]['rid'] == 2227864){
        printjson("----------------"+a['time_stamp']+'-----------------------------------');
        for(var i in eval_result){
          var tmp = {}
          tmp['rid'] = eval_result[i]['rid'];
          tmp['chips'] = eval_result[i]['chips'];
          tmp['rolename'] = eval_result[i]['rolename'];
          tmp['win_chips'] = eval_result[i]['win_chips'];
          printjson(tmp); 
        }
      }
    }
  }
)


db.props.find({'config_id':2203, 'time_stamp': {$lte:1497659459}}, {'_id':0, 'beforeprop_num':1, 'afterprop_num':1, 'time_stamp':1, 'reasion':1}).forEach(
  function(a){
    a['time_stamp'] = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    a['num'] = a['afterprop_num'] - a['beforeprop_num'];
    printjson(a);
  }
)

db.redbtabaleinfolog.find({},{'_id':0, 'now_black_cards':1, 'now_red_cards':1, 'time_stamp':1}).forEach(
  function(a){
    var time_stamp = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    var red = [];
    var bla = [];
    var now_black_cards = eval(a['now_black_cards']);
    var now_red_cards = eval(a['now_red_cards']);
    for(var i in now_black_cards){
      var b = now_black_cards[i]['card_type'] + '_' + now_black_cards[i]['card_value'];
      bla.push(b);
    }
    for(var i in now_red_cards){
      var r = now_red_cards[i]['card_type'] + '_' + now_red_cards[i]['card_value'];
      red.push(r);
    }
    var info = "RED: "+ red + " || BLACK: " + bla + "  ||TIME_"+ time_stamp;
    printjson(info);
  }
)



#德州 道具使用情况 获取道具 或者使用道具
db.props.group({
  key:{'reasion':1, 'config_id':1},
  cond: {'config_id':2203, 'time_stamp': {$lt:1497659459}},
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


金币变化
db.money.group({
  key: {'reasion': 1},
  cond: {'rid':2155456},
  initial: {'num_charge': 0, 'num_inc': 0, 'num_dec':0, 'count':0},
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


db.money.group({
  key:{'reasion':1},
  initial:{'rid_info':{}},
  reduce: function(curr, result){
    if(result.rid_info[curr.rid]){
      result.rid_info[curr.rid]['total_count'] += 1;
      if(curr.num>=0){
        result.rid_info[curr.rid]['incr_num'] += curr.num;
      }else{
        result.rid_info[curr.rid]['desc_num'] += curr.num;
      }
    }else{
      result.rid_info[curr.rid] = {};
      result.rid_info[curr.rid]['total_count'] = 1;
      if(curr.num>=0){
        result.rid_info[curr.rid]['incr_num'] = curr.num;
        result.rid_info[curr.rid]['desc_num'] = 0;
      }else{
        result.rid_info[curr.rid]['incr_num'] = 0;
        result.rid_info[curr.rid]['desc_num'] = curr.num;
      }
    }
  }
})



#德州 比赛报名情况
db.playersignup.group({
  key: {'match_instance_id':1, 'match_template_id':1,
    'condition':1, 'match_start_time':1, 'match_name':1},
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

#德州 mtt比赛信息创建
db.createmttlog.find({
  'match_instance_id': {'$exists': true}},
  {'_id':0, 'conf':0})

#德州 mtt比赛结果信息
db.tablesrecord.find({
  'match_instance_id': {'$exists': true}
  },{'_id':0})

#德州 MTT比赛报名信息
db.playersignup.group({
  key: {'match_instance_id':1,
    'condition':1,
    'match_template_id':1,
    'match_start_time':1,
    'match_name':1},
  initial: {'rid_list': {}, 'cancel_list':[]},
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
        reducor.cancel_list.push(i);
        delete reducor.rid_list[i];
      }
    }
  }
})



#德州 比赛结果信息
db.tablesrecord.find({
  'match_instance_id': {'$exists': true}},
  {'_id':0})

#德州 选手mtt比赛 总时长 奖励信息 退赛原因
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



db.match_result.group({
  key:{'match_instance_id':1,
    'match_name':1,
    'match_start_time':1,
    'match_template_id':1},
  initial: {rid_info:{}},
  reduce: function(curr, result){
    result.rid_info[curr.rid] = {
      'reason': curr.reason,
      'renk': curr.rank,
      'awards': curr.awards,
      'reward_awards': curr.reward_awards,
      'competitiontime': curr.competitiontime,
      'time_stamp': curr.time_stamp
    }
  }
})



#渠道用户 活跃人数 新增人数
db.playerslogin.group({
  key:{'channel':1},
  initial: {'active_dict': {},
    'active_list':[],
    'active_count':0,
    'active_login_count':0},
  reduce: function(curr, result){
    if(curr.rid in result.active_dict){
      result.active_dict[curr.rid] += 1;
    }else{
      result.active_dict[curr.rid] = 1;
    }
  },
  finalize: function(reducor){
    for(var i in reducor.active_dict){
      reducor.active_count += 1;
      reducor.active_login_count += reducor.active_dict[i];
      reducor.active_list.push(i);
    }
    delete reducor.active_dict;
  }
})



db.delprops.group({
  key:{'config_id':1},
  initial: {'rid_info':{}},
  reduce: function(curr, result){
    if(curr.rid in result.rid_info){
      result.rid_info[curr.rid] += curr.num;
    }else{
      result.rid_info[curr.rid] = curr.num;
    }
  }
})

#游戏场返水道具发放数量
db.backwaterprops.group({
  key: {'room_type':1},
  initial: {'props':{}},
  reduce: function(curr, result){
    var props = eval('(' + curr.props + ')');
    for(var i in props){
      if(props[i]['num'] > 0){
        if(curr.rid in result.props){
          if(result.props[curr.rid]['id'] == props[i]['id']){
            result.props[curr.rid]['num'] += props[i]['num'];
          }else{
            result.props[curr.rid]['num'] = props[i]['num'];
          }
        }else{
          result.props[curr.rid] = props[i];
        }
      }
    }
  }
})



cursor = db.matchtablelog.find({'match_instance_id':'matchsvr_11411503892800810.0'},{'_id':0, 'time_stamp':1, 'result':1})
while(cursor.hasNext()){
  var a = cursor.next();
  var X = {
      0:'黑桃2', 1:'黑桃3', 2:'黑桃4', 3:'黑桃5', 4:'黑桃6', 5:'黑桃7', 6:'黑桃8', 7:'黑桃9', 8:'黑桃10',9:'黑桃J',10:'黑桃Q',11:'黑桃K',12:'黑桃A',
      13:'红桃2',14:'红桃3',15:'红桃4',16:'红桃5',17:'红桃6',18:'红桃7',19:'红桃8',20:'红桃9',21:'红桃10',22:'红桃J',23:'红桃Q',24:'红桃K',25:'红桃A',
      26:'樱花2',27:'樱花3',28:'樱花4',29:'樱花5',30:'樱花6',31:'樱花7',32:'樱花8',33:'樱花9',34:'樱花10',35:'樱花J',36:'樱花Q',37:'樱花K',38:'樱花A',
      39:'方块2',40:'方块3',41:'方块4',42:'方块5',43:'方块6',44:'方块7',45:'方块8',46:'方块9',47:'方块10',48:'方块J',49:'方块Q',50:'方块K',51:'方块A',
    };
    var all = [];
    var tmp = {}
    var result = eval('(' + a['result'] + ')');
    var time_stamp = (new Date(a['time_stamp']*1000).toLocaleString().replace(/:\d{1,2}$/,' '));
    for(var i in result){
      tmp['rid'] = result[i]['rid'];
      tmp['role_name'] = result[i]['rolename'];
      tmp['hole_cards'] = result[i]['hole_cards'];
      tmp['win_chips'] = result[i]['win_chips'];
      tmp['时间'] = time_stamp;
      tmp['card'] = [];
      if(result[i]['form_cards'] !== '{}'){
        tmp['form_cards'] = [];
        for(var k in result[i]['form_cards']){
          tmp['form_cards'].push(X[result[i]['form_cards'][k]]);
        }
      }
      for(var j in tmp['hole_cards']){
        tmp['card'].push(X[tmp['hole_cards'][j]]);
      }
      printjson(tmp);
    }
  printjson('--------------------------');
}

mongo 127.0.0.1:27017/2017_08_29 d.js >> ./2017_08_29.vim




{
0:'黑桃2', 1:'黑桃3', 2:'黑桃4', 3:'黑桃5', 4:'黑桃6', 5:'黑桃7', 6:'黑桃8', 7:'黑桃9', 8:'黑桃10',9:'黑桃J',10:'黑桃Q',11:'黑桃K',12:'黑桃A',
13:'红桃2',14:'红桃3',15:'红桃4',16:'红桃5',17:'红桃6',18:'红桃7',19:'红桃8',20:'红桃9',21:'红桃10',22:'红桃J',23:'红桃Q',24:'红桃K',25:'红桃A',
26:'樱花2',27:'樱花3',28:'樱花4',29:'樱花5',30:'樱花6',31:'樱花7',32:'樱花8',33:'樱花9',34:'樱花10',35:'樱花J',36:'樱花Q',37:'樱花K',38:'樱花A',
39:'方块2',40:'方块3',41:'方块4',42:'方块5',43:'方块6',44:'方块7',45:'方块8',46:'方块9',47:'方块10',48:'方块J',49:'方块Q',50:'方块K',51:'方块A',
}

 var X = {
    0:'黑桃3',4:'黑桃4',8: '黑桃5',12:'黑桃6',16:'黑桃7',20:'黑桃8',24:'黑桃9',28:'黑桃10',32:'黑桃J',36:'黑桃Q',40:'黑桃K',44:'黑桃A',48:'黑桃2',
    1:'红桃3',5:'红桃4',9: '红桃5',13:'红桃6',17:'红桃7',21:'红桃8',25:'红桃9',29:'红桃10',33:'红桃J',37:'红桃Q',41:'红桃K',45:'红桃A',49:'红桃2',
    2:'樱花3',6:'樱花4',10:'樱花5',14:'樱花6',18:'樱花7',22:'樱花8',26:'樱花9',30:'樱花10',34:'樱花J',38:'樱花Q',42:'樱花K',46:'樱花A',50:'樱花2',
    3:'方块3',7:'方块4',11:'方块5',15:'方块6',19:'方块7',23:'方块8',27:'方块9',31:'方块10',35:'方块J',39:'方块Q',43:'方块K',47:'方块A',51:'方块2',
  };
