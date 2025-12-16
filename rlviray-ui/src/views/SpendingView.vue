<template>
  <SideNav>
    <div class="flex-1 flex flex-col">
      <!-- Header -->
      <div class="bg-white border-b border-gray-200 px-6 py-4">
        <div class="flex justify-between items-center">
          <div>
            <h1 class="text-2xl font-bold text-gray-900">Spending Tracker</h1>
            <p class="text-sm text-gray-600 mt-1">Track and manage your expenses</p>
          </div>

          <button
            @click="openAddExpenseDrawer"
            class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition flex items-center gap-2"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Add Expense
          </button>
        </div>

        <!-- Tabs -->
        <div class="flex gap-4 mt-4 border-b border-gray-200">
          <button
            @click="activeTab = 'overview'"
            :class="[
              'px-4 py-2 font-medium text-sm transition border-b-2',
              activeTab === 'overview'
                ? 'text-blue-600 border-blue-600'
                : 'text-gray-500 border-transparent hover:text-gray-700'
            ]"
          >
            Overview
          </button>
          <button
            @click="activeTab = 'transactions'"
            :class="[
              'px-4 py-2 font-medium text-sm transition border-b-2',
              activeTab === 'transactions'
                ? 'text-blue-600 border-blue-600'
                : 'text-gray-500 border-transparent hover:text-gray-700'
            ]"
          >
            Transactions
          </button>
        </div>
      </div>

      <!-- Content -->
      <div class="flex-1 overflow-auto p-6">
        <!-- Overview Tab -->
        <div v-if="activeTab === 'overview'" class="max-w-7xl mx-auto space-y-6">
          <!-- Summary Cards -->
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            <div class="bg-gradient-to-br from-blue-600 to-blue-700 text-white rounded-lg p-6 shadow-lg">
              <div class="flex items-center justify-between mb-2">
                <p class="text-blue-100 text-sm font-medium">Today</p>
                <svg class="w-8 h-8 text-blue-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <p class="text-3xl font-bold">₱{{ getTotalByPeriod('today').toFixed(2) }}</p>
            </div>

            <div class="bg-gradient-to-br from-green-600 to-green-700 text-white rounded-lg p-6 shadow-lg">
              <div class="flex items-center justify-between mb-2">
                <p class="text-green-100 text-sm font-medium">This Week</p>
                <svg class="w-8 h-8 text-green-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <p class="text-3xl font-bold">₱{{ getTotalByPeriod('week').toFixed(2) }}</p>
            </div>

            <div class="bg-gradient-to-br from-purple-600 to-purple-700 text-white rounded-lg p-6 shadow-lg">
              <div class="flex items-center justify-between mb-2">
                <p class="text-purple-100 text-sm font-medium">This Month</p>
                <svg class="w-8 h-8 text-purple-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <p class="text-3xl font-bold">₱{{ getTotalByPeriod('month').toFixed(2) }}</p>
            </div>

            <div class="bg-gradient-to-br from-orange-600 to-orange-700 text-white rounded-lg p-6 shadow-lg">
              <div class="flex items-center justify-between mb-2">
                <p class="text-orange-100 text-sm font-medium">This Year</p>
                <svg class="w-8 h-8 text-orange-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                </svg>
              </div>
              <p class="text-3xl font-bold">₱{{ getTotalByPeriod('year').toFixed(2) }}</p>
            </div>
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Expenses by Category -->
            <div class="bg-white rounded-lg shadow">
              <div class="px-6 py-4 border-b border-gray-200">
                <h3 class="text-lg font-semibold text-gray-900">Expenses by Category</h3>
              </div>
              <div class="p-6">
                <div v-if="categoryExpenses.length === 0" class="text-center py-8 text-gray-500">
                  <p>No expenses yet</p>
                </div>
                <div v-else class="space-y-4">
                  <div
                    v-for="catExpense in categoryExpenses"
                    :key="catExpense.category"
                    class="space-y-2"
                  >
                    <div class="flex items-center justify-between">
                      <div class="flex items-center gap-2">
                        <span class="text-xl">{{ getCategoryIcon(catExpense.category) }}</span>
                        <span class="text-sm font-medium text-gray-700">
                          {{ getCategoryLabel(catExpense.category) }}
                        </span>
                        <span class="text-xs text-gray-500">
                          ({{ catExpense.count }} {{ catExpense.count === 1 ? 'item' : 'items' }})
                        </span>
                      </div>
                      <span class="font-semibold text-gray-900">
                        ₱{{ catExpense.total.toFixed(2) }}
                      </span>
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-2">
                      <div
                        :class="['h-2 rounded-full', getCategoryColor(catExpense.category)]"
                        :style="{ width: `${getCategoryPercentage(catExpense.total)}%` }"
                      ></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Budget Status -->
            <div class="bg-white rounded-lg shadow">
              <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
                <h3 class="text-lg font-semibold text-gray-900">Budget Status</h3>
                <button
                  @click="showBudgetDialog = true"
                  class="text-sm text-blue-600 hover:text-blue-700 font-medium"
                >
                  Manage Budgets
                </button>
              </div>
              <div class="p-6">
                <div v-if="budgets.length === 0" class="text-center py-8 text-gray-500">
                  <p>No budgets set</p>
                  <button
                    @click="showBudgetDialog = true"
                    class="text-blue-600 hover:text-blue-700 text-sm mt-2"
                  >
                    Set your first budget →
                  </button>
                </div>
                <div v-else class="space-y-4">
                  <div
                    v-for="budget in budgets"
                    :key="budget.category"
                    class="space-y-2"
                  >
                    <div class="flex items-center justify-between">
                      <div class="flex items-center gap-2">
                        <span class="text-xl">{{ getCategoryIcon(budget.category) }}</span>
                        <div>
                          <p class="text-sm font-medium text-gray-700">
                            {{ getCategoryLabel(budget.category) }}
                          </p>
                          <p class="text-xs text-gray-500">{{ budget.period }}ly limit</p>
                        </div>
                      </div>
                      <div class="text-right">
                        <p class="font-semibold text-gray-900">
                          ₱{{ getBudgetStatus(budget.category).spent.toFixed(2) }} / ₱{{ budget.limit.toFixed(2) }}
                        </p>
                        <p
                          :class="[
                            'text-xs font-medium',
                            getBudgetStatus(budget.category).remaining < 0 ? 'text-red-600' : 'text-green-600'
                          ]"
                        >
                          {{ getBudgetStatus(budget.category).remaining >= 0 ? 'Remaining: ' : 'Over: ' }}
                          ₱{{ Math.abs(getBudgetStatus(budget.category).remaining).toFixed(2) }}
                        </p>
                      </div>
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-2">
                      <div
                        :class="[
                          'h-2 rounded-full transition-all',
                          getBudgetStatus(budget.category).percentage >= 100 ? 'bg-red-500' :
                          getBudgetStatus(budget.category).percentage >= 80 ? 'bg-yellow-500' : 'bg-green-500'
                        ]"
                        :style="{ width: `${Math.min(getBudgetStatus(budget.category).percentage, 100)}%` }"
                      ></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Transactions Tab -->
        <div v-if="activeTab === 'transactions'" class="max-w-7xl mx-auto">
          <div class="bg-white rounded-lg shadow">
            <div class="px-6 py-4 border-b border-gray-200">
              <h3 class="text-lg font-semibold text-gray-900">All Transactions</h3>
            </div>
            <div class="overflow-x-auto">
              <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Date
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Category
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Description
                    </th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Payment
                    </th>
                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Amount
                    </th>
                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                  <tr v-if="expenses.length === 0">
                    <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                      <p class="text-lg mb-2">No expenses yet</p>
                      <p class="text-sm">Click "Add Expense" to track your first expense</p>
                    </td>
                  </tr>
                  <tr
                    v-for="expense in expenses"
                    :key="expense.id"
                    class="hover:bg-gray-50 transition"
                  >
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      {{ formatDate(expense.date) }}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span class="inline-flex items-center gap-2">
                        <span>{{ getCategoryIcon(expense.category) }}</span>
                        <span class="text-sm text-gray-700">{{ getCategoryLabel(expense.category) }}</span>
                      </span>
                    </td>
                    <td class="px-6 py-4 text-sm text-gray-900">
                      {{ expense.description }}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {{ getPaymentMethodLabel(expense.paymentMethod) }}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-semibold text-gray-900">
                      ₱{{ expense.amount.toFixed(2) }}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <div class="flex justify-end gap-2">
                        <button
                          @click="handleEditExpense(expense)"
                          class="text-blue-600 hover:text-blue-900 p-1 hover:bg-blue-50 rounded transition"
                          title="Edit"
                        >
                          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                          </svg>
                        </button>
                        <button
                          @click="handleDeleteExpense(expense.id)"
                          class="text-red-600 hover:text-red-900 p-1 hover:bg-red-50 rounded transition"
                          title="Delete"
                        >
                          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                        </button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Expense Drawer -->
    <ExpenseDrawer
      :is-open="isExpenseDrawerOpen"
      :mode="expenseDrawerMode"
      :expense="selectedExpense"
      @close="closeExpenseDrawer"
      @submit="handleAddExpense"
      @update="handleUpdateExpense"
    />

    <!-- Budget Dialog -->
    <div
      v-if="showBudgetDialog"
      class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4"
      @click.self="showBudgetDialog = false"
    >
      <div class="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
        <h3 class="text-xl font-semibold text-gray-900 mb-4">Manage Budgets</h3>
        <p class="text-sm text-gray-600 mb-4">
          Set spending limits for different categories to help manage your finances.
        </p>
        <div class="text-center py-8 text-gray-500">
          <p>Budget management coming soon!</p>
        </div>
        <button
          @click="showBudgetDialog = false"
          class="w-full bg-gray-100 hover:bg-gray-200 text-gray-700 font-medium py-2 rounded-lg transition"
        >
          Close
        </button>
      </div>
    </div>
  </SideNav>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useSpending, Expense, EXPENSE_CATEGORIES, PAYMENT_METHODS } from '../composables/useSpending'
import SideNav from '../components/SideNav.vue'
import ExpenseDrawer from '../components/ExpenseDrawer.vue'

const {
  expenses,
  budgets,
  createExpense,
  updateExpense,
  deleteExpense,
  getTotalByPeriod,
  getExpensesByCategory,
  getCategoryBudgetStatus
} = useSpending()

const isExpenseDrawerOpen = ref(false)
const expenseDrawerMode = ref<'add' | 'edit'>('add')
const selectedExpense = ref<Expense | null>(null)
const showBudgetDialog = ref(false)
const activeTab = ref<'overview' | 'transactions'>('overview')

const categoryExpenses = computed(() => getExpensesByCategory())

const getCategoryIcon = (category: string): string => {
  return EXPENSE_CATEGORIES.find(c => c.value === category)?.icon || '💰'
}

const getCategoryLabel = (category: string): string => {
  return EXPENSE_CATEGORIES.find(c => c.value === category)?.label || category
}

const getCategoryColor = (category: string): string => {
  return EXPENSE_CATEGORIES.find(c => c.value === category)?.color || 'bg-gray-500'
}

const getPaymentMethodLabel = (method?: string): string => {
  if (!method) return '—'
  return PAYMENT_METHODS.find(m => m.value === method)?.label || method
}

const getCategoryPercentage = (amount: number): number => {
  const total = categoryExpenses.value.reduce((sum, cat) => sum + cat.total, 0)
  return total > 0 ? (amount / total) * 100 : 0
}

const getBudgetStatus = (category: string) => {
  return getCategoryBudgetStatus(category)
}

const formatDate = (dateString: string): string => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  })
}

const openAddExpenseDrawer = () => {
  expenseDrawerMode.value = 'add'
  selectedExpense.value = null
  isExpenseDrawerOpen.value = true
}

const handleAddExpense = async (data: Omit<Expense, 'id' | 'createdAt' | 'updatedAt'>) => {
  await createExpense(data)
}

const handleEditExpense = (expense: Expense) => {
  expenseDrawerMode.value = 'edit'
  selectedExpense.value = expense
  isExpenseDrawerOpen.value = true
}

const handleUpdateExpense = async (id: number, data: Partial<Omit<Expense, 'id' | 'createdAt'>>) => {
  await updateExpense(id, data)
}

const handleDeleteExpense = async (id: number) => {
  if (confirm('Are you sure you want to delete this expense?')) {
    await deleteExpense(id)
  }
}

const closeExpenseDrawer = () => {
  isExpenseDrawerOpen.value = false
}
</script>
