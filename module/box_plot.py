import matplotlib.pyplot as plt


download_time = []
with open("./time.txt") as f:
    download_time = f.read().split()
    download_time = [float(s) for s in download_time]
    print(download_time)

fig = plt.figure()
ax = fig.add_subplot(111)
bp = ax.boxplot(download_time, showmeans=True)

ax.set_xticklabels(['version1', 'version2'])

#グリッド線を表示
plt.grid()

plt.xlabel('situation')
plt.ylabel('download time[s]')
plt.title('box plot of download time')
plt.show()

