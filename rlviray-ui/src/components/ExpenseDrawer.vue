<template>
  <!-- Backdrop -->
  <transition name="fade">
    <div
      v-if="isOpen"
      class="fixed inset-0 bg-black bg-opacity-50 z-40 transition-opacity"
      @click="closeDrawer"
    ></div>
  </transition>

  <!-- Drawer -->
  <transition name="slide">
    <div
      v-if="isOpen"
      class="fixed right-0 top-0 h-full w-full sm:w-[500px] bg-white shadow-xl z-50 flex flex-col"
    >
      <!-- Header -->
      <div class="bg-gray-50 px-6 py-4 border-b border-gray-200 flex justify-between items-center">
        <h3 class="text-xl font-semibold text-gray-900">
          {{ mode === 'add' ? 'Add Expense' : 'Edit Expense' }}
        </h3>
        <button
          @click="closeDrawer"
          class="text-gray-400 hover:text-gray-600 transition"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <!-- Form Content -->
      <div class="flex-1 overflow-y-auto px-6 py-6">
        <form @submit.prevent="handleSubmit" class="space-y-5">
          <div>
            <label for="expense-amount" class="block text-sm font-medium text-gray-700 mb-2">
              Amount <span class="text-red-500">*</span>
            </label>
            <div class="relative">
              <span class="absolute left-4 top-2.5 text-gray-500 font-medium">₱</span>
              <input
                id="expense-amount"
                v-model.number="formData.amount"
                type="number"
                step="0.01"
                min="0"
                required
                class="w-full pl-8 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="0.00"
              />
            </div>
          </div>

          <div>
            <label for="expense-category" class="block text-sm font-medium text-gray-700 mb-2">
              Category <span class="text-red-500">*</span>
            </label>
            <select
              id="expense-category"
              v-model="formData.category"
              required
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">Select a category</option>
              <option
                v-for="cat in EXPENSE_CATEGORIES"
                :key="cat.value"
                :value="cat.value"
              >
                {{ cat.icon }} {{ cat.label }}
              </option>
            </select>
          </div>

          <div>
            <label for="expense-description" class="block text-sm font-medium text-gray-700 mb-2">
              Description <span class="text-red-500">*</span>
            </label>
            <input
              id="expense-description"
              v-model="formData.description"
              type="text"
              required
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="What did you spend on?"
            />
          </div>

          <div>
            <label for="expense-date" class="block text-sm font-medium text-gray-700 mb-2">
              Date <span class="text-red-500">*</span>
            </label>
            <input
              id="expense-date"
              v-model="formData.date"
              type="date"
              required
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>

          <div>
            <label for="expense-payment" class="block text-sm font-medium text-gray-700 mb-2">
              Payment Method
            </label>
            <select
              id="expense-payment"
              v-model="formData.paymentMethod"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">Select payment method</option>
              <option
                v-for="method in PAYMENT_METHODS"
                :key="method.value"
                :value="method.value"
              >
                {{ method.label }}
              </option>
            </select>
          </div>

          <div v-if="successMessage" class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-lg text-sm">
            {{ successMessage }}
          </div>

          <div v-if="errorMessage" class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm">
            {{ errorMessage }}
          </div>
        </form>
      </div>

      <!-- Footer -->
      <div class="border-t border-gray-200 px-6 py-4 bg-gray-50">
        <div class="flex gap-3">
          <button
            @click="handleSubmit"
            :disabled="loading"
            class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-medium py-2.5 px-4 rounded-lg transition disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {{ loading ? 'Saving...' : mode === 'add' ? 'Add Expense' : 'Save Changes' }}
          </button>
          <button
            type="button"
            @click="closeDrawer"
            class="px-6 py-2.5 text-gray-700 hover:bg-gray-200 rounded-lg transition font-medium"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { Expense, EXPENSE_CATEGORIES, PAYMENT_METHODS } from '../composables/useSpending'

const props = defineProps<{
  isOpen: boolean
  mode: 'add' | 'edit'
  expense: Expense | null
}>()

const emit = defineEmits<{
  close: []
  submit: [data: Omit<Expense, 'id' | 'createdAt' | 'updatedAt'>]
  update: [id: number, data: Partial<Omit<Expense, 'id' | 'createdAt'>>]
}>()

const formData = ref<Omit<Expense, 'id' | 'createdAt' | 'updatedAt'>>({
  amount: 0,
  category: '',
  description: '',
  date: new Date().toISOString().split('T')[0],
  paymentMethod: ''
})

const loading = ref(false)
const successMessage = ref('')
const errorMessage = ref('')

watch(
  () => props.expense,
  (newExpense) => {
    if (newExpense && props.mode === 'edit') {
      formData.value = {
        amount: newExpense.amount,
        category: newExpense.category,
        description: newExpense.description,
        date: newExpense.date,
        paymentMethod: newExpense.paymentMethod || ''
      }
    }
    successMessage.value = ''
    errorMessage.value = ''
  },
  { immediate: true }
)

watch(
  () => props.isOpen,
  (isOpen) => {
    if (isOpen && props.mode === 'add') {
      resetForm()
    }
  }
)

const resetForm = () => {
  formData.value = {
    amount: 0,
    category: '',
    description: '',
    date: new Date().toISOString().split('T')[0],
    paymentMethod: ''
  }
  successMessage.value = ''
  errorMessage.value = ''
}

const closeDrawer = () => {
  emit('close')
  setTimeout(() => {
    if (props.mode === 'add') {
      resetForm()
    }
  }, 300)
}

const handleSubmit = async () => {
  loading.value = true
  successMessage.value = ''
  errorMessage.value = ''

  try {
    const data = {
      amount: formData.value.amount,
      category: formData.value.category,
      description: formData.value.description,
      date: formData.value.date,
      paymentMethod: formData.value.paymentMethod || undefined
    }

    if (props.mode === 'add') {
      emit('submit', data)
      successMessage.value = 'Expense added successfully!'
      setTimeout(() => {
        closeDrawer()
      }, 1000)
    } else if (props.mode === 'edit' && props.expense) {
      emit('update', props.expense.id, data)
      successMessage.value = 'Expense updated successfully!'
      setTimeout(() => {
        closeDrawer()
      }, 1000)
    }
  } catch (error) {
    console.error('Error saving expense:', error)
    errorMessage.value = 'Failed to save expense. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-enter-active,
.slide-leave-active {
  transition: transform 0.3s ease;
}

.slide-enter-from,
.slide-leave-to {
  transform: translateX(100%);
}
</style>
