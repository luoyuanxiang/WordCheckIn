
export function convertMillisecondsToTime(timeUsed: number) {
  const hours = Math.floor(timeUsed / 3600000);
  const minutes = Math.floor((timeUsed % 3600000) / 60000);
  const seconds = Math.floor((timeUsed % 60000) / 1000);
  if (hours > 0) {
    return `${hours}时 ${minutes}分 ${seconds}秒`;
  } else if (minutes > 0) {
    return `${minutes}分 ${seconds}秒`;
  }
  return `${seconds}秒`;
}