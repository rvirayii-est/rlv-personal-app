import { ref, computed } from 'vue'
import * as XLSX from 'xlsx'

export interface Link {
  id: number
  title: string
  url: string
  description?: string
  category?: string
  createdAt: string
  updatedAt: string
}

export interface LinkImportRow {
  title: string
  url: string
  description?: string
  category?: string
}

const links = ref<Link[]>([])
const isInitialized = ref(false)

export function useLinks() {
  const loadLinks = () => {
    // TODO: Replace with actual API call
    const storedLinks = localStorage.getItem('savedLinks')
    if (storedLinks) {
      links.value = JSON.parse(storedLinks)
    } else {
      // Initialize with dummy data
      links.value = [
        {
          id: 1,
          title: 'Vue.js Documentation',
          url: 'https://vuejs.org',
          description: 'Official Vue.js documentation',
          category: 'Development',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 2,
          title: 'TypeScript Handbook',
          url: 'https://www.typescriptlang.org/docs/',
          description: 'Learn TypeScript from the official handbook',
          category: 'Development',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        },
        {
          id: 3,
          title: 'Tailwind CSS',
          url: 'https://tailwindcss.com',
          description: 'Utility-first CSS framework',
          category: 'Design',
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        }
      ]
      saveToStorage()
    }
  }

  const saveToStorage = () => {
    localStorage.setItem('savedLinks', JSON.stringify(links.value))
  }

  const createLink = async (linkData: Omit<Link, 'id' | 'createdAt' | 'updatedAt'>): Promise<Link> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const newLink: Link = {
        ...linkData,
        id: Date.now(),
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      }
      links.value.unshift(newLink)
      saveToStorage()
      resolve(newLink)
    })
  }

  const updateLink = async (id: number, linkData: Partial<Omit<Link, 'id' | 'createdAt'>>): Promise<Link | null> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const index = links.value.findIndex(link => link.id === id)
      if (index !== -1) {
        links.value[index] = {
          ...links.value[index],
          ...linkData,
          updatedAt: new Date().toISOString()
        }
        saveToStorage()
        resolve(links.value[index])
      } else {
        resolve(null)
      }
    })
  }

  const deleteLink = async (id: number): Promise<boolean> => {
    // TODO: Replace with actual API call
    return new Promise((resolve) => {
      const index = links.value.findIndex(link => link.id === id)
      if (index !== -1) {
        links.value.splice(index, 1)
        saveToStorage()
        resolve(true)
      } else {
        resolve(false)
      }
    })
  }

  const getLinkById = (id: number): Link | undefined => {
    return links.value.find(link => link.id === id)
  }

  const getLinksByCategory = (category: string): Link[] => {
    return links.value.filter(link => link.category === category)
  }

  const downloadTemplate = () => {
    // Create sample data for the template
    const templateData = [
      {
        Title: 'Example Link 1',
        URL: 'https://example.com',
        Description: 'This is a sample description',
        Category: 'General'
      },
      {
        Title: 'Example Link 2',
        URL: 'https://example2.com',
        Description: 'Another sample description',
        Category: 'Work'
      }
    ]

    // Create worksheet
    const ws = XLSX.utils.json_to_sheet(templateData)

    // Set column widths
    ws['!cols'] = [
      { wch: 30 }, // Title
      { wch: 40 }, // URL
      { wch: 50 }, // Description
      { wch: 20 }  // Category
    ]

    // Create workbook
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, 'Links')

    // Download
    XLSX.writeFile(wb, 'links_template.xlsx')
  }

  const importFromExcel = async (file: File): Promise<{ success: number; errors: string[] }> => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader()

      reader.onload = async (e) => {
        try {
          const data = e.target?.result
          const workbook = XLSX.read(data, { type: 'binary' })

          // Get first sheet
          const sheetName = workbook.SheetNames[0]
          const worksheet = workbook.Sheets[sheetName]

          // Convert to JSON
          const jsonData = XLSX.utils.sheet_to_json(worksheet) as any[]

          let successCount = 0
          const errors: string[] = []

          // Process each row
          for (let i = 0; i < jsonData.length; i++) {
            const row = jsonData[i]
            const rowNumber = i + 2 // +2 because Excel rows start at 1 and we have a header

            // Validate required fields
            const title = row.Title || row.title
            const url = row.URL || row.url

            if (!title || !url) {
              errors.push(`Row ${rowNumber}: Missing required fields (Title and URL are required)`)
              continue
            }

            // Validate URL format
            try {
              new URL(url)
            } catch {
              errors.push(`Row ${rowNumber}: Invalid URL format`)
              continue
            }

            // Create link
            try {
              await createLink({
                title: title.toString(),
                url: url.toString(),
                description: row.Description || row.description || '',
                category: row.Category || row.category || ''
              })
              successCount++
            } catch (error) {
              errors.push(`Row ${rowNumber}: Failed to create link - ${error}`)
            }
          }

          resolve({ success: successCount, errors })
        } catch (error) {
          reject(new Error('Failed to parse Excel file. Please make sure it is a valid Excel file.'))
        }
      }

      reader.onerror = () => {
        reject(new Error('Failed to read file'))
      }

      reader.readAsBinaryString(file)
    })
  }

  const exportToExcel = () => {
    if (links.value.length === 0) {
      alert('No links to export')
      return
    }

    // Prepare data for export
    const exportData = links.value.map(link => ({
      Title: link.title,
      URL: link.url,
      Description: link.description || '',
      Category: link.category || '',
      'Created At': new Date(link.createdAt).toLocaleDateString(),
      'Updated At': new Date(link.updatedAt).toLocaleDateString()
    }))

    // Create worksheet
    const ws = XLSX.utils.json_to_sheet(exportData)

    // Set column widths
    ws['!cols'] = [
      { wch: 30 }, // Title
      { wch: 40 }, // URL
      { wch: 50 }, // Description
      { wch: 20 }, // Category
      { wch: 15 }, // Created At
      { wch: 15 }  // Updated At
    ]

    // Create workbook
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, 'Links')

    // Download
    const timestamp = new Date().toISOString().split('T')[0]
    XLSX.writeFile(wb, `links_export_${timestamp}.xlsx`)
  }

  // Initialize on first use
  if (!isInitialized.value) {
    loadLinks()
    isInitialized.value = true
  }

  return {
    links: computed(() => links.value),
    createLink,
    updateLink,
    deleteLink,
    getLinkById,
    getLinksByCategory,
    loadLinks,
    downloadTemplate,
    importFromExcel,
    exportToExcel
  }
}
