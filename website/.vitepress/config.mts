import { defineConfig } from 'vitepress'
import llmstxt from 'vitepress-plugin-llms'

const siteUrl = 'https://cachemanager.beyondthecloud.dev'
const siteTitle = 'Cache Manager'
const siteDescription = 'Simplified interface for Salesforce Platform Cache. One Apex API for org cache, session cache and in-memory transaction cache, with key validation and a consistent get, put and remove interface. Free, MIT licensed, part of Apex Fluently by Beyond The Cloud.'

export default defineConfig({
  cleanUrls: true,
  lang: 'en-US',
  title: siteTitle,
  description: siteDescription,
  base: '/',
  head: [
    ["link", { rel: "icon", href: "/favicon.ico" }],
    // Bing Webmaster Tools site verification
    ["meta", { name: "msvalidate.01", content: "E86DF40B08FDAC5301E67AD10EFB3E28" }],
    ['meta', { name: 'author', content: 'Beyond The Cloud' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:site_name', content: siteTitle }],
    ['meta', { property: 'og:image', content: `${siteUrl}/og-image.png` }],
    ['meta', { name: 'twitter:card', content: 'summary_large_image' }],
    ['meta', { name: 'twitter:image', content: `${siteUrl}/og-image.png` }],
    [
      'script',
      { type: 'application/ld+json' },
      JSON.stringify({
        '@context': 'https://schema.org',
        '@type': 'SoftwareApplication',
        name: siteTitle,
        description: siteDescription,
        url: siteUrl,
        applicationCategory: 'DeveloperApplication',
        operatingSystem: 'Salesforce',
        license: 'https://opensource.org/licenses/MIT',
        codeRepository: 'https://github.com/beyond-the-cloud-dev/cache-manager',
        isPartOf: { '@type': 'SoftwareApplication', name: 'Apex Fluently', url: 'https://apexfluently.beyondthecloud.dev' },
        offers: { '@type': 'Offer', price: '0', priceCurrency: 'USD' },
        author: {
          '@type': 'Organization',
          name: 'Beyond The Cloud',
          url: 'https://beyondthecloud.dev',
          sameAs: ['https://github.com/beyond-the-cloud-dev', 'https://www.linkedin.com/company/beyondtheclouddev']
        }
      })
    ],
    // Google Analytics (G-EVMRCQS34V)
    [
      'script',
      { async: '', src: 'https://www.googletagmanager.com/gtag/js?id=G-EVMRCQS34V' }
    ],
    [
      'script',
      {},
      `window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'G-EVMRCQS34V');`
    ]
  ],
  sitemap: {
    hostname: siteUrl
  },
  vite: {
    plugins: [llmstxt({ domain: siteUrl })]
  },
  transformPageData(pageData) {
    let canonicalUrl = `${siteUrl}/${pageData.relativePath}`
      .replace(/index\.md$/, '')
      .replace(/\.md$/, '')
      .replace(/\/$/, '')
    pageData.frontmatter.head ??= []
    pageData.frontmatter.head.push(
      ['link', { rel: 'canonical', href: canonicalUrl || siteUrl }],
      ['meta', { property: 'og:url', content: canonicalUrl || siteUrl }]
    )
    // Markdown twin built by vitepress-plugin-llms (llms.txt for the home page), served by middleware.js on Accept: text/markdown
    const markdownPath = pageData.relativePath === 'index.md' ? 'llms.txt' : pageData.relativePath.replace(/\/index\.md$/, '.md')
    pageData.frontmatter.head.push(['link', { rel: 'alternate', type: 'text/markdown', href: `${siteUrl}/${markdownPath}` }])
    const pageTitle = pageData.frontmatter.title || pageData.title
    pageData.frontmatter.head.push(
      ['meta', { property: 'og:title', content: pageTitle && pageTitle !== siteTitle ? `${pageTitle} | ${siteTitle}` : siteTitle }],
      ['meta', { property: 'og:description', content: pageData.frontmatter.description || pageData.description || siteDescription }]
    )
  },
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

    footer: false,

    search: {
      provider: 'local'
    }
  }
})
