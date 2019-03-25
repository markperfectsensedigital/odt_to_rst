<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
                xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" >
    <xsl:output method="text"/>
    <xsl:template match="/">
    Hi there!
        <xsl:apply-templates select="office:document-content/office:body" />
    All done
   </xsl:template>

<xsl:template match="text:p[@text:style-name='P17']">
    <xsl:variable name="underline" select="." />
    <xsl:value-of select="."/>
    <xsl:value-of select="translate($underline,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -','=========================================================')"/>
</xsl:template>

</xsl:stylesheet>

<!--  saxon -s:source.xml  -xsl:stylesheet.xsl -o:output.rst -->
<!--  saxon  -s:/tmp/barf/content.xml  -xsl:transform.xsl -->