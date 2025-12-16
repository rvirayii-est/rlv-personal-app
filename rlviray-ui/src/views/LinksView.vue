<template>
  <SideNav>
    <div class="flex-1 flex flex-col">
    <!-- Header -->
    <div class="bg-white border-b border-gray-200 px-6 py-4">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-2xl font-bold text-gray-900">My Saved Links</h1>
          <p class="text-sm text-gray-600 mt-1">Organize and access your favorite links</p>
        </div>

        <div class="flex gap-2">
          <!-- Import/Export Dropdown -->
          <div class="relative">
            <button
              @click="showImportExportMenu = !showImportExportMenu"
              class="bg-gray-100 hover:bg-gray-200 text-gray-700 px-4 py-2 rounded-lg transition flex items-center gap-2"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
              </svg>
              Import/Export
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
              </svg>
            </button>

            <!-- Dropdown Menu -->
            <div
              v-if="showImportExportMenu"
              class="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-lg border border-gray-200 z-10"
            >
              <button
                @click="handleDownloadTemplate"
                class="w-full text-left px-4 py-3 hover:bg-gray-50 transition flex items-center gap-3 border-b border-gray-100"
              >
                <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                <div>
                  <p class="text-sm font-medium text-gray-900">Download Template</p>
                  <p class="text-xs text-gray-500">Get Excel template with examples</p>
                </div>
              </button>
              <button
                @click="handleImportClick"
                class="w-full text-left px-4 py-3 hover:bg-gray-50 transition flex items-center gap-3 border-b border-gray-100"
              >
                <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M9 19l3 3m0 0l3-3m-3 3v-6" />
                </svg>
                <div>
                  <p class="text-sm font-medium text-gray-900">Import from Excel</p>
                  <p class="text-xs text-gray-500">Upload filled template</p>
                </div>
              </button>
              <button
                @click="handleExport"
                class="w-full text-left px-4 py-3 hover:bg-gray-50 transition flex items-center gap-3"
              >
                <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
                <div>
                  <p class="text-sm font-medium text-gray-900">Export to Excel</p>
                  <p class="text-xs text-gray-500">Download current links</p>
                </div>
              </button>
            </div>
          </div>

          <button
            @click="openAddLinkDrawer"
            class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition flex items-center gap-2"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 4v16m8-8H4"
              />
            </svg>
            Add New Link
          </button>
        </div>
      </div>
    </div>

    <!-- Content -->
    <div class="p-6">
      <LinkTable
        :links="links"
        @edit="handleEditLink"
        @delete="handleDeleteLink"
      />
    </div>

    <!-- Link Drawer -->
    <LinkDrawer
      :is-open="isLinkDrawerOpen"
      :mode="linkDrawerMode"
      :link="selectedLink"
      @close="closeLinkDrawer"
      @submit="handleAddLink"
      @update="handleUpdateLink"
    />

    <!-- Import Dialog -->
    <div
      v-if="showImportDialog"
      class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4"
      @click.self="closeImportDialog"
    >
      <div class="bg-white rounded-lg shadow-xl max-w-lg w-full p-6">
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-xl font-semibold text-gray-900">Import Links from Excel</h3>
          <button
            @click="closeImportDialog"
            class="text-gray-400 hover:text-gray-600 transition"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <div class="space-y-4">
          <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <div class="flex gap-3">
              <svg class="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <div class="text-sm text-blue-800">
                <p class="font-medium mb-1">How to import:</p>
                <ol class="list-decimal list-inside space-y-1">
                  <li>Download the Excel template</li>
                  <li>Fill in your links (Title and URL are required)</li>
                  <li>Upload the completed file below</li>
                </ol>
              </div>
            </div>
          </div>

          <div
            @click="triggerFileInput"
            @dragover.prevent="isDragging = true"
            @dragleave.prevent="isDragging = false"
            @drop.prevent="handleFileDrop"
            :class="[
              'border-2 border-dashed rounded-lg p-8 text-center cursor-pointer transition',
              isDragging ? 'border-blue-500 bg-blue-50' : 'border-gray-300 hover:border-gray-400'
            ]"
          >
            <input
              ref="fileInput"
              type="file"
              accept=".xlsx,.xls"
              @change="handleFileSelect"
              class="hidden"
            />
            <svg class="w-12 h-12 mx-auto text-gray-400 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
            </svg>
            <p class="text-sm text-gray-600 mb-1">
              {{ selectedFile ? selectedFile.name : 'Click to upload or drag and drop' }}
            </p>
            <p class="text-xs text-gray-500">Excel files (.xlsx, .xls)</p>
          </div>

          <div v-if="importResult" class="rounded-lg p-4" :class="importResult.errors.length > 0 ? 'bg-yellow-50 border border-yellow-200' : 'bg-green-50 border border-green-200'">
            <div class="flex gap-2">
              <svg v-if="importResult.errors.length === 0" class="w-5 h-5 text-green-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              <svg v-else class="w-5 h-5 text-yellow-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
              <div class="text-sm">
                <p class="font-medium" :class="importResult.errors.length > 0 ? 'text-yellow-800' : 'text-green-800'">
                  Successfully imported {{ importResult.success }} link{{ importResult.success !== 1 ? 's' : '' }}
                </p>
                <div v-if="importResult.errors.length > 0" class="mt-2 space-y-1">
                  <p class="font-medium text-yellow-800">Errors:</p>
                  <ul class="list-disc list-inside text-yellow-700 max-h-32 overflow-y-auto">
                    <li v-for="(error, index) in importResult.errors" :key="index" class="text-xs">
                      {{ error }}
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>

          <div class="flex gap-3">
            <button
              @click="handleImportSubmit"
              :disabled="!selectedFile || isImporting"
              class="flex-1 bg-blue-600 hover:bg-blue-700 text-white font-medium py-2.5 px-4 rounded-lg transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {{ isImporting ? 'Importing...' : 'Import Links' }}
            </button>
            <button
              @click="closeImportDialog"
              class="px-6 py-2.5 text-gray-700 hover:bg-gray-100 rounded-lg transition font-medium"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
    </div>
  </SideNav>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useLinks, Link } from '../composables/useLinks'
import SideNav from '../components/SideNav.vue'
import LinkTable from '../components/LinkTable.vue'
import LinkDrawer from '../components/LinkDrawer.vue'

const { links, createLink, updateLink, deleteLink, downloadTemplate, importFromExcel, exportToExcel } = useLinks()

// Link drawer state
const isLinkDrawerOpen = ref(false)
const linkDrawerMode = ref<'add' | 'edit'>('add')
const selectedLink = ref<Link | null>(null)

// Import/Export state
const showImportExportMenu = ref(false)
const showImportDialog = ref(false)
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)
const isImporting = ref(false)
const isDragging = ref(false)
const importResult = ref<{ success: number; errors: string[] } | null>(null)

// Link handlers
const openAddLinkDrawer = () => {
  linkDrawerMode.value = 'add'
  selectedLink.value = null
  isLinkDrawerOpen.value = true
}

const handleAddLink = async (data: { title: string; url: string; description?: string; category?: string }) => {
  await createLink(data)
}

const handleEditLink = (link: Link) => {
  linkDrawerMode.value = 'edit'
  selectedLink.value = link
  isLinkDrawerOpen.value = true
}

const handleUpdateLink = async (id: number, data: { title: string; url: string; description?: string; category?: string }) => {
  await updateLink(id, data)
}

const handleDeleteLink = async (id: number) => {
  await deleteLink(id)
}

const closeLinkDrawer = () => {
  isLinkDrawerOpen.value = false
}

// Import/Export handlers
const handleDownloadTemplate = () => {
  downloadTemplate()
  showImportExportMenu.value = false
}

const handleImportClick = () => {
  showImportDialog.value = true
  showImportExportMenu.value = false
  selectedFile.value = null
  importResult.value = null
}

const handleExport = () => {
  exportToExcel()
  showImportExportMenu.value = false
}

const triggerFileInput = () => {
  fileInput.value?.click()
}

const handleFileSelect = (event: Event) => {
  const target = event.target as HTMLInputElement
  if (target.files && target.files.length > 0) {
    selectedFile.value = target.files[0]
  }
}

const handleFileDrop = (event: DragEvent) => {
  isDragging.value = false
  if (event.dataTransfer?.files && event.dataTransfer.files.length > 0) {
    const file = event.dataTransfer.files[0]
    if (file.name.endsWith('.xlsx') || file.name.endsWith('.xls')) {
      selectedFile.value = file
    } else {
      alert('Please upload an Excel file (.xlsx or .xls)')
    }
  }
}

const handleImportSubmit = async () => {
  if (!selectedFile.value) return

  isImporting.value = true
  importResult.value = null

  try {
    const result = await importFromExcel(selectedFile.value)
    importResult.value = result

    if (result.success > 0) {
      // Reset file selection after successful import
      setTimeout(() => {
        if (result.errors.length === 0) {
          closeImportDialog()
        }
      }, 2000)
    }
  } catch (error) {
    alert(error instanceof Error ? error.message : 'Failed to import file')
  } finally {
    isImporting.value = false
  }
}

const closeImportDialog = () => {
  showImportDialog.value = false
  selectedFile.value = null
  importResult.value = null
  if (fileInput.value) {
    fileInput.value.value = ''
  }
}

// Close dropdown when clicking outside
const handleClickOutside = (event: MouseEvent) => {
  const target = event.target as HTMLElement
  if (!target.closest('.relative')) {
    showImportExportMenu.value = false
  }
}

// Add event listener for closing dropdown
if (typeof window !== 'undefined') {
  window.addEventListener('click', handleClickOutside)
}
</script>
