import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "Cache Manager",
  description: "Simplified interface for Salesforce Platform Cache",
  base: '/',
  themeConfig: {
    logo: '/logo.png',

    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/getting-started' },
      { text: 'API', link: '/api' }
    ],

    sidebar: [
      {
        text: 'Introduction',
        items: [
          { text: 'Getting Started', link: '/getting-started' },
          { text: 'Installation', link: '/installation' }
        ]
      },
      {
        text: 'Cache Types',
        items: [
          { text: 'Transaction Cache', link: '/caches/transaction' },
          { text: 'Org Cache', link: '/caches/org' },
          { text: 'Session Cache', link: '/caches/session' }
        ]
      },
      {
        text: 'Usage',
        items: [
          { text: 'API Reference', link: '/api' },
          { text: 'Examples', link: '/examples' },
          { text: 'Best Practices', link: '/best-practices' }
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/beyond-the-cloud-dev/cache-manager' }
    ],

    footer: {
      message: 'Part of <a href="https://apexfluently.beyondthecloud.dev">Apex Fluently</a>',
      copyright: 'Copyright © 2024 <a href="https://beyondthecloud.dev">Beyond the Cloud</a>'
    },

    search: {
      provider: 'local'
    }
  }
})
