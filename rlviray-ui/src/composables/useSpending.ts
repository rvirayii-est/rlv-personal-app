import { ref, computed } from 'vue'

export interface Expense {
  id: number
  amount: number
  category: string
  description: string
  date: string // ISO date string
  paymentMethod?: string
  createdAt: string
  updatedAt: string
}

export interface Budget {
  category: string
  limit: number
  period: 'daily' | 'weekly' | 'monthly'
}

export const EXPENSE_CATEGORIES = [
  { value: 'food', label: 'Food & Dining', icon: '🍔', color: 'bg-orange-500' },
  { value: 'transport', label: 'Transportation', icon: '🚗', color: 'bg-blue-500' },
  { value: 'shopping', label: 'Shopping', icon: '🛍️', color: 'bg-pink-500' },
  { value: 'entertainment', label: 'Entertainment', icon: '🎬', color: 'bg-purple-500' },
  { value: 'bills', label: 'Bills & Utilities', icon: '📄', color: 'bg-red-500' },
  { value: 'health', label: 'Health & Fitness', icon: '💊', color: 'bg-green-500' },
  { value: 'education', label: 'Education', icon: '📚', color: 'bg-indigo-500' },
  { value: 'travel', label: 'Travel', icon: '✈️', color: 'bg-cyan-500' },
  { value: 'housing', label: 'Housing', icon: '🏠', color: 'bg-yellow-600' },
  { value: 'other', label: 'Other', icon: '💰', color: 'bg-gray-500' }
]

export const PAYMENT_METHODS = [
  { value: 'cash', label: 'Cash' },
  { value: 'credit_card', label: 'Credit Card' },
  { value: 'debit_card', label: 'Debit Card' },
  { value: 'digital_wallet', label: 'Digital Wallet' },
  { value: 'bank_transfer', label: 'Bank Transfer' },
  { value: 'other', label: 'Other' }
]

const expenses = ref<Expense[]>([])
const budgets = ref<Budget[]>([])
const isInitialized = ref(false)

export function useSpending() {
  const loadExpenses = () => {
    // TODO: Replace with actual API call
    const storedExpenses = localStorage.getItem('expenses')
    const storedBudgets = localStorage.getItem('budgets')

    if (storedExpenses) {
      expenses.value = JSON.parse(storedExpenses)
    } else {
      // Initialize with dummy data
      const today = new Date()
      const yesterday = new Date(today)
      yesterday.setDate(yesterday.getDate() - 1)
      const lastWeek = new Date(today)
      lastWeek.setDate(lastWeek.getDate() - 7)

      expenses.value = [
        {
          id: 1,
          amount: 45.50,
          category: 'food',
          description: 'Lunch at restaurant',
          date: today.toISOString().split('T')[0],
          paymentMethod: 'credit_card',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 2,
          amount: 120.00,
          category: 'shopping',
          description: 'New shoes',
          date: yesterday.toISOString().split('T')[0],
          paymentMethod: 'debit_card',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 3,
          amount: 15.00,
          category: 'transport',
          description: 'Uber ride',
          date: yesterday.toISOString().split('T')[0],
          paymentMethod: 'digital_wallet',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 4,
          amount: 89.99,
          category: 'bills',
          description: 'Internet bill',
          date: lastWeek.toISOString().split('T')[0],
          paymentMethod: 'bank_transfer',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 5,
          amount: 25.00,
          category: 'entertainment',
          description: 'Movie tickets',
          date: lastWeek.toISOString().split('T')[0],
          paymentMethod: 'cash',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        }
      ]
      saveToStorage()
    }

    if (storedBudgets) {
      budgets.value = JSON.parse(storedBudgets)
    } else {
      // Default budgets
      budgets.value = [
        { category: 'food', limit: 500, period: 'monthly' },
        { category: 'transport', limit: 200, period: 'monthly' },
        { category: 'entertainment', limit: 150, period: 'monthly' }
      ]
      saveToStorage()
    }
  }

  const saveToStorage = () => {
    localStorage.setItem('expenses', JSON.stringify(expenses.value))
    localStorage.setItem('budgets', JSON.stringify(budgets.value))
  }

  const createExpense = async (expenseData: Omit<Expense, 'id' | 'createdAt' | 'updatedAt'>): Promise<Expense> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const newExpense: Expense = {
        ...expenseData,
        id: Date.now(),
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      }
      expenses.value.unshift(newExpense)
      saveToStorage()
      resolve(newExpense)
    })
  }

  const updateExpense = async (id: number, expenseData: Partial<Omit<Expense, 'id' | 'createdAt'>>): Promise<Expense | null> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const index = expenses.value.findIndex(expense => expense.id === id)
      if (index !== -1) {
        expenses.value[index] = {
          ...expenses.value[index],
          ...expenseData,
          updatedAt: new Date().toISOString()
        }
        saveToStorage()
        resolve(expenses.value[index])
      } else {
        resolve(null)
      }
    })
  }

  const deleteExpense = async (id: number): Promise<boolean> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const index = expenses.value.findIndex(expense => expense.id === id)
      if (index !== -1) {
        expenses.value.splice(index, 1)
        saveToStorage()
        resolve(true)
      } else {
        resolve(false)
      }
    })
  }

  const getTotalByPeriod = (period: 'today' | 'week' | 'month' | 'year'): number => {
    const now = new Date()
    const startDate = new Date()

    switch (period) {
      case 'today':
        startDate.setHours(0, 0, 0, 0)
        break
      case 'week':
        startDate.setDate(now.getDate() - now.getDay())
        startDate.setHours(0, 0, 0, 0)
        break
      case 'month':
        startDate.setDate(1)
        startDate.setHours(0, 0, 0, 0)
        break
      case 'year':
        startDate.setMonth(0, 1)
        startDate.setHours(0, 0, 0, 0)
        break
    }

    return expenses.value
      .filter(expense => new Date(expense.date) >= startDate)
      .reduce((total, expense) => total + expense.amount, 0)
  }

  const getExpensesByCategory = (): { category: string; total: number; count: number }[] => {
    const categoryMap = new Map<string, { total: number; count: number }>()

    expenses.value.forEach(expense => {
      const existing = categoryMap.get(expense.category) || { total: 0, count: 0 }
      categoryMap.set(expense.category, {
        total: existing.total + expense.amount,
        count: existing.count + 1
      })
    })

    return Array.from(categoryMap.entries()).map(([category, data]) => ({
      category,
      ...data
    })).sort((a, b) => b.total - a.total)
  }

  const getCategoryBudgetStatus = (category: string): {
    budget: Budget | null
    spent: number
    remaining: number
    percentage: number
  } => {
    const budget = budgets.value.find(b => b.category === category)
    if (!budget) {
      return { budget: null, spent: 0, remaining: 0, percentage: 0 }
    }

    const now = new Date()
    let startDate = new Date()

    switch (budget.period) {
      case 'daily':
        startDate.setHours(0, 0, 0, 0)
        break
      case 'weekly':
        startDate.setDate(now.getDate() - now.getDay())
        startDate.setHours(0, 0, 0, 0)
        break
      case 'monthly':
        startDate.setDate(1)
        startDate.setHours(0, 0, 0, 0)
        break
    }

    const spent = expenses.value
      .filter(e => e.category === category && new Date(e.date) >= startDate)
      .reduce((total, e) => total + e.amount, 0)

    const remaining = budget.limit - spent
    const percentage = Math.min((spent / budget.limit) * 100, 100)

    return { budget, spent, remaining, percentage }
  }

  const setBudget = (category: string, limit: number, period: 'daily' | 'weekly' | 'monthly') => {
    const existingIndex = budgets.value.findIndex(b => b.category === category)
    if (existingIndex !== -1) {
      budgets.value[existingIndex] = { category, limit, period }
    } else {
      budgets.value.push({ category, limit, period })
    }
    saveToStorage()
  }

  const removeBudget = (category: string) => {
    const index = budgets.value.findIndex(b => b.category === category)
    if (index !== -1) {
      budgets.value.splice(index, 1)
      saveToStorage()
    }
  }

  // Initialize on first use
  if (!isInitialized.value) {
    loadExpenses()
    isInitialized.value = true
  }

  return {
    expenses: computed(() => expenses.value),
    budgets: computed(() => budgets.value),
    createExpense,
    updateExpense,
    deleteExpense,
    getTotalByPeriod,
    getExpensesByCategory,
    getCategoryBudgetStatus,
    setBudget,
    removeBudget,
    loadExpenses
  }
}
