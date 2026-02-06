import { motion } from 'framer-motion'

export default function Hero() {
  return (
    <section className="pt-12 max-w-6xl mx-auto px-4">
      <motion.div
        initial={{ opacity: 0, y: 8 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="grid gap-10 md:grid-cols-2 items-center"
      >
        {/* Left content */}
        <div>
          <h1 className="text-4xl md:text-5xl font-extrabold text-primary-500 leading-tight">
            Secure pipelines, faster delivery
          </h1>
          <p className="mt-4 text-gray-700 dark:text-gray-300">
            I build automated CI/CD pipelines with security in mind. I merge infrastructure, policy, and testing into reliable, repeatable releases.
          </p>
          <div className="mt-6 flex flex-col sm:flex-row gap-4">
            <a
              href="/projects"
              className="bg-secondary-700 text-white px-6 py-3 rounded-xl shadow hover:bg-secondary-600 transition-colors text-center"
            >
              View Projects
            </a>
            <a
              href="/contact"
              className="px-6 py-3 rounded-xl border border-gray-300 dark:border-gray-700 hover:bg-gray-100 dark:hover:bg-gray-800 text-center transition-colors"
            >
              Contact
            </a>
          </div>
        </div>

        {/* Right featured card */}
        <motion.div
          initial={{ scale: 0.98, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.7 }}
          className="bg-linear-to-br from-primary-500 to-indigo-500 rounded-3xl p-6 text-white shadow-xl"
        >
          <div className="text-sm font-medium opacity-90">Featured</div>
          <h3 className="mt-4 text-2xl font-bold">Portfolio Overview</h3>
          <p className="mt-2 opacity-90">
            Highlights of CI/CD, IaC, and security automations.
          </p>
          <div className="mt-4 grid grid-cols-2 gap-3">
            <div className="bg-white/10 p-3 rounded-lg text-center">CI/CD</div>
            <div className="bg-white/10 p-3 rounded-lg text-center">Terraform</div>
            <div className="bg-white/10 p-3 rounded-lg text-center">Security</div>
            <div className="bg-white/10 p-3 rounded-lg text-center">Testing</div>
          </div>
        </motion.div>
      </motion.div>
    </section>
  )
}
