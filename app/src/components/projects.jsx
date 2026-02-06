import Card from './Card'

export default function Projects() {
  const items = [
    {
      title: 'CI CD Security for Portfolio Application',
      description: 'Enforced CI pipelines with dependency scanning, secrets detection, and filesystem vulnerability checks.',
      tags: ['CI CD', 'DevSecOps', 'Trivy', 'Gitleaks'],
      repoUrl: 'https://github.com/asadyare/portfolio-ci-security',
      badgeUrl: 'https://github.com/asadyare/portfolio-ci-security/actions/workflows/ci-security.yml/badge.svg'
    },
    {
      title: 'Threat Modeling and Risk Analysis',
      description: 'Structured threat modeling with risks mapped to implemented controls.',
      tags: ['Threat Modeling', 'Risk Analysis', 'Security Design'],
      repoUrl: 'https://github.com/asadyare/portfolio-threat-model'
    },
    {
      title: 'Daily Security Monitoring',
      description: 'Scheduled security checks detecting dependency and vulnerability drift.',
      tags: ['Monitoring', 'GitHub Actions', 'Trivy'],
      repoUrl: 'https://github.com/asadyare/portfolio-daily-security',
      badgeUrl: 'https://github.com/asadyare/portfolio-daily-security/actions/workflows/daily-dependency-scan.yml/badge.svg'
    }
  ]

  return (
    <section className="py-12">
      <h2 className="text-2xl font-bold text-primary-500">Projects</h2>

      <div className="mt-6 grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {items.map(item => (
          <Card
            key={item.title}
            title={item.title}
            description={item.description}
            tags={item.tags}
            repoUrl={item.repoUrl}
            badgeUrl={item.badgeUrl}
          />
        ))}
      </div>
    </section>
  )
}
