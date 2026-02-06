export default function Footer() {
  return (
    <footer className="py-8 bg-gray-100 dark:bg-gray-900 text-gray-700 dark:text-gray-300">
      <div className="max-w-6xl mx-auto px-4 flex flex-col md:flex-row items-center justify-between">
        
        <div className="text-center md:text-left">
          <p className="font-semibold">Asad Hassan</p>
          <p className="text-sm mt-1">&copy; 2026. All rights reserved.</p>
        </div>
        
        <div className="flex space-x-4 mt-4 md:mt-0">
          <a
            href="https://github.com/asadyare"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:text-primary-500 transition-colors"
          >
            GitHub
          </a>
          <a
            href="https://www.linkedin.com/in/asad-hassan-20b540313/"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:text-primary-500 transition-colors"
          >
            LinkedIn
          </a>
          <a
            href="mailto:walasaqo@gmail.com"
            className="hover:text-primary-500 transition-colors"
          >
            Email
          </a>
        </div>
      </div>
    </footer>
  )
}
