<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
  xmlns:cv="http://example.org/cv#">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>
  <xsl:variable name="lang" select="/portfolio/langue/@active"/>

  <xsl:template match="/">
    <div vocab="http://xmlns.com/foaf/0.1/" typeof="foaf:Person" about="#me">

      <!-- SECTION INTRO -->
      <main>
        <div class="intro slide-in">
          <p class="role" property="cv:role">
            <xsl:value-of select="/portfolio/infos/roles/role[@lang=$lang]"/>
          </p>
          <h2>
            <span id="typewriter-wrapper">
              <span id="typewriter" property="foaf:name">
                <xsl:value-of select="/portfolio/infos/presentation/texte[@lang=$lang]"/>
              </span>
            </span>
          </h2>
          <p class="desc" property="cv:summary">
            <xsl:value-of select="/portfolio/infos/intro/texte[@lang=$lang]"/>
          </p>
          <div class="actions">
            <a class="btn" rel="cv:hasCV">
              <xsl:attribute name="href">
                <xsl:value-of select="/portfolio/infos/cv[@lang=$lang]/@lien"/>
              </xsl:attribute>
              <span class="download" property="dc:title">
                <xsl:value-of select="/portfolio/infos/cv[@lang=$lang]"/>
              </span>
            </a>
          </div>
        </div>

        <div class="photo slide-in">
          <div class="circle"></div>
            <xsl:element name="img">
              <xsl:attribute name="property">foaf:img</xsl:attribute>
              <xsl:attribute name="typeof">foaf:Image</xsl:attribute>
              <xsl:attribute name="src">
                <xsl:value-of select="/portfolio/infos/photo"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:choose>
                  <xsl:when test="$lang='fr'">
                    <xsl:value-of select="/portfolio/infos/photo/@alt_fr"/>
                  </xsl:when>
                  <xsl:when test="$lang='en'">
                    <xsl:value-of select="/portfolio/infos/photo/@alt_en"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="/portfolio/infos/photo/@alt_ar"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </xsl:element>
        </div>
      </main>

      <!-- STATS -->
      <section class="stats slide-in" typeof="cv:Statistics">
        <xsl:for-each select="/portfolio/stats/item">
          <div>
            <strong property="cv:value"><xsl:value-of select="valeur"/></strong>
            <span property="cv:label"><xsl:value-of select="libelle[@lang=$lang]"/></span>
          </div>
        </xsl:for-each>
      </section>

      <div class="section-separator"></div>

      <!-- VIDÉO -->
      <section class="slide-in visible" id="intro-video" typeof="cv:VideoSection">
        <h2 class="video-title" property="dc:title">
          <xsl:value-of select="/portfolio/titres/video[@lang=$lang]"/>
        </h2>
        <div class="video-wrapper video-frame">
          <iframe width="100%" height="450" frameborder="0" allowfullscreen="true" property="cv:videoEmbed">
            <xsl:attribute name="src">
              <xsl:value-of select="/portfolio/video/lien[@lang=$lang]"/>
            </xsl:attribute>
          </iframe>
        </div>
      </section>

      <!-- PARCOURS SCOLAIRE -->
      <section class="education slide-in" id="education" typeof="cv:EducationSection">
        <h2 class="edu-title" property="dc:title">
          <xsl:value-of select="/portfolio/titres/education[@lang=$lang]"/>
        </h2>
        <div class="section-content">
          <xsl:for-each select="/portfolio/education/item">
            <div class="card" typeof="cv:Education">
              <h3 property="cv:period"><xsl:value-of select="periode"/></h3>
              <p property="dc:description"><xsl:value-of select="texte[@lang=$lang]"/></p>
            </div>
          </xsl:for-each>
        </div>
      </section>

      <!-- EXPÉRIENCE -->
      <section class="experience slide-in" id="experience" typeof="cv:ExperienceSection">
        <h2 class="exp-title" property="dc:title">
          <xsl:value-of select="/portfolio/titres/experience[@lang=$lang]"/>
        </h2>
        <div class="section-content">
          <xsl:for-each select="/portfolio/experience/item">
            <div class="card" typeof="cv:Experience">
              <h3 property="cv:period"><xsl:value-of select="periode"/></h3>
              <p><strong property="cv:position"><xsl:value-of select="poste[@lang=$lang]"/></strong></p>
              <ul>
                <xsl:for-each select="details[@lang=$lang]/point">
                  <li property="cv:task"><xsl:value-of select="."/></li>
                </xsl:for-each>
              </ul>
            </div>
          </xsl:for-each>
        </div>
      </section>

      <!-- PROJETS -->
      <section class="projects slide-in" id="projects" typeof="cv:Portfolio">
        <h2 class="proj-title" property="dc:title">
          <xsl:value-of select="/portfolio/titres/projects[@lang=$lang]"/>
        </h2>
        <div class="section-content">
          <xsl:for-each select="/portfolio/projects/item">
            <div class="card" typeof="cv:Project">
              <h3 property="dc:title"><xsl:value-of select="nom"/></h3>
              <p property="dc:description"><xsl:value-of select="desc[@lang=$lang]"/></p>
            </div>
          </xsl:for-each>
        </div>
      </section>

      <!-- TECHNOLOGIES -->
      <section class="technos slide-in" id="technos" typeof="cv:SkillsSection">
        <h2 class="tech-title" property="dc:title">
          <xsl:value-of select="/portfolio/titres/technos[@lang=$lang]"/>
        </h2>
        <div class="tech-grid">
          <xsl:for-each select="/portfolio/technos/tech">
            <div typeof="cv:Skill">
              <img property="foaf:depiction">
                <xsl:attribute name="src">
                  <xsl:text>https://cdn.jsdelivr.net/gh/devicons/devicon/icons/</xsl:text>
                  <xsl:value-of select="translate(., '.', '')"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="translate(., '.', '')"/>
                  <xsl:text>-original.svg</xsl:text>
                </xsl:attribute>
              </img>
              <p property="dc:title"><xsl:value-of select="."/></p>
            </div>
          </xsl:for-each>
        </div>
      </section>

      <!-- LANGUES PARLÉES -->
      <section class="languages slide-in" id="languages" typeof="cv:LanguageSection">
        <h2 class="lang-title" property="dc:title">
          <xsl:value-of select="/portfolio/titres/languages[@lang=$lang]"/>
        </h2>
        <div class="lang-grid">
          <xsl:for-each select="/portfolio/languages/lang">
            <div typeof="cv:LanguageSkill">
              <p property="cv:language"><xsl:value-of select="nom[@lang=$lang]"/></p>
              <span property="cv:level"><xsl:value-of select="niveau[@lang=$lang]"/></span>
            </div>
          </xsl:for-each>
        </div>
      </section>

      <!-- CONTACT -->
      <section class="contact slide-in" id="contact" typeof="vcard:Individual">
        <h2 class="lang-title" property="dc:title">
          Contact
        </h2>
        <div class="lang-grid">
          <div>
            <p><strong>Email</strong></p>
            <p property="vcard:email">
              <xsl:value-of select="/portfolio/contact/email"/>
            </p>
          </div>
          <div>
            <p><strong>GitHub</strong></p>
            <p>
              <a property="foaf:account" typeof="foaf:OnlineAccount">
                <xsl:attribute name="href">
                  <xsl:value-of select="/portfolio/contact/github"/>
                </xsl:attribute>
                GitHub
              </a>
            </p>
          </div>
          <div>
            <p><strong>LinkedIn</strong></p>
            <p>
              <a property="foaf:account" typeof="foaf:OnlineAccount">
                <xsl:attribute name="href">
                  <xsl:value-of select="/portfolio/contact/linkedin"/>
                </xsl:attribute>
                LinkedIn
              </a>
            </p>
          </div>
        </div>
      </section>

    </div>
  </xsl:template>
</xsl:stylesheet>
