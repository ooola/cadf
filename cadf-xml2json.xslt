<?xml version="1.0"?>
<!-- Copyright (c) ola.nordstrom@citrix.com -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8" indent="no"/>

<xsl:template match="/Event">
    <xsl:text>{</xsl:text> 
    <xsl:text>"Event": {</xsl:text>

    <xsl:apply-templates select="typeURI | id | eventType | eventTime | initiator | action | target | outcome"/>
    <xsl:text>,</xsl:text>

    <!-- reporter chain is mandatory -->
    <xsl:apply-templates select="reporterchain"/>

    <!-- if there are more optional attributes append a comma and the
         attribute -->
    <xsl:if test="./reason">
        <xsl:text>,</xsl:text>
        <xsl:apply-templates select="reason"/>
    </xsl:if>

    <xsl:if test="./measurements">
        <xsl:text>,</xsl:text>
        <xsl:apply-templates select="measurements"/>
    </xsl:if>

    <xsl:if test="./attachments">
        <xsl:text>,</xsl:text>
        <xsl:apply-templates select="attachments"/>
    </xsl:if>

    <xsl:text>}</xsl:text>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="/Geolocation">
    <xsl:text>{</xsl:text> 
    <xsl:text>"Geolocation": {</xsl:text>

    <xsl:apply-templates select="id | latitude | longitude | elevation | accuracy | city | state | regionICANN"/>

    <xsl:if test="./annotation">
        <xsl:if test="./id | ./latitude | ./longitude | ./elevation | ./accuracy | ./city | ./state | ./regionICANN">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>"annotation": {</xsl:text>
        <xsl:for-each select="./annotation">
            <xsl:text>"</xsl:text><xsl:value-of select="@key"/><xsl:text>": </xsl:text>
            <xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>}</xsl:text>
    </xsl:if>

    <xsl:text>}</xsl:text>
    <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="id | latitude | longitude | elevation | accuracy | city | state | regionICANN |
                     typeURI | id | eventType | eventTime | initiator | action | target | outcome |
                     reason">
    <xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>": "</xsl:text>
    <xsl:value-of select="."/><xsl:text>"</xsl:text>

    <xsl:if test="position() != last()">
        <xsl:text>,</xsl:text>
    </xsl:if>
</xsl:template>

<xsl:template match="measurements | attachments">
    <xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>": {</xsl:text>
    <xsl:for-each select="child::*">
        <xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>": "</xsl:text>
        <xsl:value-of select="."/><xsl:text>"</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
</xsl:template>

<!-- TODO: handle the reporter chain list better and include the details -->
<xsl:template match="reporterchain">
    <xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>": [</xsl:text>
    <xsl:for-each select="child::*">
        <xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:for-each>
    <xsl:text>]</xsl:text>
</xsl:template>

</xsl:stylesheet>
