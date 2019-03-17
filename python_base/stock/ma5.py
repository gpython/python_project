import pandas as pd

#5 10日均值
df = pd.read_csv("../../000858.csv", index_col="date", parse_dates=["date"])

# 1#shift
# cs = df.sort_index()["close"].cumsum()

# df["ma5"] = (cs - cs.shift(1).fillna(0).shift(4))/5
# df["ma10"]  = (cs - cs.shift(1).fillna(0).shift(9))/10

# 2#rolling
# df["ma5"] = df.sort_index()["close"].rolling(5).mean()
# df["ma10"] = df.sort_index()["close"].rolling(10).mean()

print(df["ma5"])
#金叉
#5日均线上穿10日均线

"""
gloden_cross = []
death_cross = []

#ma5[t] >= ma10[t] and ma5[t-1] < ma10[t-1]
sr = df["ma5"] >= df["ma10"]

for i in range(1, len(sr)):
  if sr.iloc[i] == True and sr.iloc[i-1] == False:
    gloden_cross.append(sr.index[i])
  if sr.iloc[i] == False and sr.iloc[i-1] == True:
    death_cross.append(sr.index[i])

print(gloden_cross, death_cross)
"""

gloden_cross = df[(df["ma5"] >= df["ma10"]) & (df["ma5"] < df["ma10"]).shift(1)].index
death_cross = df[(df["ma5"] <= df["ma10"]) & (df["ma5"] > df["ma10"]).shift(1)].index
print(gloden_cross, death_cross)


