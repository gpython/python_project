#encoding:utf-8

def wordcount(file="./decorator_03.py"):
  chars = """~!@#$%^&*()_+<>?:"{}|=;'"""
  with open(file, encoding="utf-8") as f:
    word_count = {}
    for line in f:
      words = line.split()

      #zip
      for k, v in zip(words, (1,)*len(words)):
        k = k.strip(chars).lower()

        word_count[k] = word_count.get(k, 0) + 1

  lst = sorted(word_count.items(), key=lambda x:x[1], reverse=True)
  for i in range(10):
    print(str(lst[i]).strip("'()").replace("'",""))

  return lst

print(wordcount())