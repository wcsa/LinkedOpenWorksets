<?xml version="1.0"?>
<xsl:transform
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:terms="http://purl.org/dc/terms/"
  xmlns:w="http://registry.htrc.i3.illinois.edu/entities/workset"
  xmlns:workset="http://wcsa.htrc.illinois.edu/#"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="w"
  version="1.0">

  <xsl:output format="xml" indent="yes"/>

  <xsl:strip-space elements="*"/>

  <!-- When we go to convert worksets for real, we will put them in
       users’ own namespaces, not the sample-data one. -->
  <xsl:param name="sample" select="true()"/>

  <xsl:variable
    name="username"
    select="normalize-space(/w:workset/w:metadata/w:author)"/>

  <xsl:variable
    name="workset-name"
    select="normalize-space(/w:workset/w:metadata/w:name)"/>

  <xsl:template match="/">
    <rdf:RDF>
      <owl:Ontology
        rdf:about="http://wcsa.htrc.illinois.edu/sample-data">
        <owl:imports
          rdf:resource="http://wcsa.htrc.illinois.edu/1.0"/>
        <owl:versionIRI
          rdf:resource="http://wcsa.htrc.illinois.edu/sample-data/1.0"/>
      </owl:Ontology>
      <xsl:apply-templates/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="w:author">
    <owl:NamedIndividual
      rdf:about="http://wcsa.htrc.illinois.edu/sample-data/users/{$username}">
      <rdf:type rdf:resource="http://purl.org/dc/terms/Agent"/>
      <terms:identifier
        rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
        <xsl:value-of select="."/>
      </terms:identifier>
    </owl:NamedIndividual>
  </xsl:template>

  <xsl:template match="w:description">
    <xsl:if test="normalize-space(.)">
      <terms:abstract
        rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
        <xsl:apply-templates/>
      </terms:abstract>
    </xsl:if>
  </xsl:template>

  <xsl:template match="w:lastModified">
    <terms:modified
      rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
      <xsl:value-of select="normalize-space(.)"/>
    </terms:modified>
  </xsl:template>

  <xsl:template match="w:metadata">
    <xsl:apply-templates select="w:author"/>
    <owl:NamedIndividual
      rdf:about="http://wcsa.htrc.illinois.edu/sample-data/users/{$username}#{$workset-name}">
      <rdf:type
        rdf:resource="http://wcsa.htrc.illinois.edu/#Workset"/>
      <xsl:apply-templates select="w:lastModified"/>
      <xsl:apply-templates select="w:name"/>
      <terms:creator
        rdf:resource="http://wcsa.htrc.illinois.edu/sample-data/users/{$username}"/>
      <xsl:apply-templates select="w:description"/>
      <xsl:apply-templates select="../w:content"
        mode="workset-content"/>
    </owl:NamedIndividual>
  </xsl:template>

  <xsl:template match="w:name">
    <terms:title
      rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
      <xsl:value-of select="."/>
    </terms:title>
  </xsl:template>

  <xsl:template match="w:volume">
    <owl:NamedIndividual
      rdf:about="http://hdl.handle.net/2027/{normalize-space(w:id)}">
      <rdf:type
        rdf:resource="http://wcsa.htrc.illinois.edu/#Volume"/>
    </owl:NamedIndividual>
  </xsl:template>

  <xsl:template match="w:workset">
    <xsl:apply-templates select="w:metadata"/>
    <xsl:apply-templates select="w:content"/>
  </xsl:template>

  <xsl:template match="w:volume" mode="workset-content">
    <workset:gathers
      rdf:resource="http://hdl.handle.net/2027/{normalize-space(w:id)}"/>
  </xsl:template>

</xsl:transform>