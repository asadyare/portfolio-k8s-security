import { motion } from 'framer-motion'

export default function Card({ title, description, tags, repoUrl, badgeUrl }) {
  return (
    <motion.article
      whileHover={{ y: -6, scale: 1.01 }}
      className="card rounded-lg border p-6"
    >
      <div className="flex items-start justify-between gap-3">
        <h3 className="text-lg font-semibold text-primary-500">
          {title}
        </h3>

        {badgeUrl && (
          <img
            src={badgeUrl}
            alt="ci status"
            className="h-5"
          />
        )}
      </div>

      <p className="mt-2 text-gray-700 dark:text-gray-300">
        {description}
      </p>

      <div className="mt-4 flex flex-wrap gap-2">
        {tags.map(t => (
          <span
            key={t}
            className="text-sm px-2 py-1 bg-gray-100 dark:bg-gray-700 rounded-full"
          >
            {t}
          </span>
        ))}
      </div>

      {repoUrl && (
        <a
          href={repoUrl}
          target="_blank"
          rel="noreferrer"
          className="mt-4 inline-block text-sm underline"
        >
          View repository
        </a>
      )}
    </motion.article>
  )
}
