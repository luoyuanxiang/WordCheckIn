export interface Question {
  word: string; // 单词
  sentence: string; // 例句
  options: string[]; // 选项
  answer: string; // 答案
}

export const questionData: Question[] = [
  {
    word: 'book',
    options: ['书籍', '笔', '橡皮', '背包'],
    answer: '书籍',
    sentence: 'I like to read books.'
  },
  {
    word: 'computer',
    options: ['电视', '电脑', '手机', '相机'],
    answer: '电脑',
    sentence: 'I like to use computer.'
  },
  {
    word: 'apple',
    options: ['香蕉', '桃子', '梨', '苹果'],
    answer: '苹果',
    sentence: 'I like to eat apple.'
  },
  {
    word: 'sun',
    options: ['月亮', '太阳', '星星', '地球'],
    answer: '太阳',
    sentence: 'I like to see the sun.'
  },
]

// 从题库中随机抽取n个题目
export function getRandomQuestion(count: number): Question[] {
  // 获取题库
  return questionData.sort(() => Math.random() - 0.5).slice(0, count)
}