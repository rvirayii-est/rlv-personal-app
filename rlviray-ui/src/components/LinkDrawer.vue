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
          {{ mode === 'add' ? 'Add New Link' : 'Edit Link' }}
        </h3>
        <button
          @click="closeDrawer"
          class="text-gray-400 hover:text-gray-600 transition"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>

      <!-- Form Content -->
      <div class="flex-1 overflow-y-auto px-6 py-6">
        <form @submit.prevent="handleSubmit" class="space-y-5">
          <div>
            <label for="drawer-title" class="block text-sm font-medium text-gray-700 mb-2">
              Title <span class="text-red-500">*</span>
            </label>
            <input
              id="drawer-title"
              v-model="formData.title"
              type="text"
              required
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="Enter link title"
            />
          </div>

          <div>
            <label for="drawer-url" class="block text-sm font-medium text-gray-700 mb-2">
              URL <span class="text-red-500">*</span>
            </label>
            <input
              id="drawer-url"
              v-model="formData.url"
              type="url"
              required
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="https://example.com"
            />
          </div>

          <div>
            <label for="drawer-description" class="block text-sm font-medium text-gray-700 mb-2">
              Description
            </label>
            <textarea
              id="drawer-description"
              v-model="formData.description"
              rows="4"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
              placeholder="Optional description"
            />
          </div>

          <div>
            <label for="drawer-category" class="block text-sm font-medium text-gray-700 mb-2">
              Category
            </label>
            <input
              id="drawer-category"
              v-model="formData.category"
              type="text"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="e.g., Development, Design, Resources"
            />
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
            {{ loading ? 'Saving...' : mode === 'add' ? 'Add Link' : 'Save Changes' }}
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
import { Link } from '../composables/useLinks'

const props = defineProps<{
  isOpen: boolean
  mode: 'add' | 'edit'
  link: Link | null
}>()

const emit = defineEmits<{
  close: []
  submit: [data: { title: string; url: string; description?: string; category?: string }]
  update: [id: number, data: { title: string; url: string; description?: string; category?: string }]
}>()

const formData = ref({
  title: '',
  url: '',
  description: '',
  category: ''
})

const loading = ref(false)
const successMessage = ref('')
const errorMessage = ref('')

watch(
  () => props.link,
  (newLink) => {
    if (newLink && props.mode === 'edit') {
      formData.value = {
        title: newLink.title,
        url: newLink.url,
        description: newLink.description || '',
        category: newLink.category || ''
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
    title: '',
    url: '',
    description: '',
    category: ''
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
      title: formData.value.title,
      url: formData.value.url,
      description: formData.value.description || undefined,
      category: formData.value.category || undefined
    }

    if (props.mode === 'add') {
      emit('submit', data)
      successMessage.value = 'Link added successfully!'
      setTimeout(() => {
        closeDrawer()
      }, 1000)
    } else if (props.mode === 'edit' && props.link) {
      emit('update', props.link.id, data)
      successMessage.value = 'Link updated successfully!'
      setTimeout(() => {
        closeDrawer()
      }, 1000)
    }
  } catch (error) {
    console.error('Error saving link:', error)
    errorMessage.value = 'Failed to save link. Please try again.'
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
