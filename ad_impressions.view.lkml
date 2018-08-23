include: "ad.view"
include: "age_range.view"
include: "audience.view"
include: "gender.view"
include: "geotargeting.view"
include: "keyword.view"
include: "parental_status.view"
include: "video.view"

view: hour_base {
  extension: required

  dimension: hour_of_day {
    hidden: yes
    type: number
    sql: ${TABLE}.HourOfDay ;;
  }
}

view: transformations_base {
  extension: required

  dimension: ad_network_type {
    hidden: yes
    type: string
    case: {
      when: {
        sql: ${ad_network_type1} = 'SHASTA_AD_NETWORK_TYPE_1_SEARCH' AND ${ad_network_type2} = 'SHASTA_AD_NETWORK_TYPE_2_SEARCH' ;;
        label: "Search"
      }
      when: {
        sql: ${ad_network_type1} = 'SHASTA_AD_NETWORK_TYPE_1_SEARCH' AND ${ad_network_type2} = 'SHASTA_AD_NETWORK_TYPE_2_SEARCH_PARTNERS' ;;
        label: "Search Partners"
      }
      when: {
        sql: ${ad_network_type1} = 'SHASTA_AD_NETWORK_TYPE_1_CONTENT' ;;
        label: "Content"
      }
      else: "Other"
    }
  }

  dimension: device_type {
    hidden: yes
    type: string
    case: {
      when: {
        sql: ${device} LIKE '%Desktop%' ;;
        label: "Desktop"
      }
      when: {
        sql: ${device} LIKE '%Mobile%' ;;
        label: "Mobile"
      }
      when: {
        sql: ${device} LIKE '%Tablet%' ;;
        label: "Tablet"
      }
      else: "Other"
    }
  }
}

explore: ad_impressions_adapter {
  extends: [customer_join]
  persist_with: adwords_etl_datagroup
  label: "Ad Impressions"
  view_label: "Ad Impressions"
  from: ad_impressions_adapter
  view_name: fact
  hidden: yes
}

view: ad_impressions_adapter {
  extends: [google_adwords_base, transformations_base]

  derived_table: {
    sql:
        SELECT
          CURRENT_DATE as _DATA_DATE,
          CURRENT_DATE as _LATEST_DATE,
          CAST('NA' as TEXT) as ExternalCustomerId,
          0 as AveragePosition,
          0 as ActiveViewImpressions,
          0 as ActiveViewMeasurability,
          0 as ActiveViewMeasurableCost,
          0 as ActiveViewMeasurableImpressions,
          0 as ActiveViewViewability,
          CAST('NA' as TEXT) as AdNetworkType1,
          CAST('NA' as TEXT) as AdNetworkType2,
          0 as clicks,
          0 as conversions,
          0 as conversionvalue,
          0 as cost,
          CAST('NA' as TEXT) as Device,
          0 as impressions,
          0 as Interactions,
          CAST('NA' as TEXT) as InteractionTypes,
          CAST('NA' as TEXT) as Slot,
          0 as ViewThroughConversions,
          CAST('NA' as TEXT) as CampaignId,
          CAST('NA' as TEXT) as AdGroupId,
          CAST('NA' as TEXT) as CriterionId
        ;;
  }

  dimension: average_position {
    hidden: yes
    type: number
    sql: ${TABLE}.AveragePosition ;;
  }

  dimension: active_view_impressions {
    hidden: yes
    type: number
    sql: ${TABLE}.ActiveViewImpressions ;;
  }

  dimension: active_view_measurability {
    hidden: yes
    type: number
    sql: ${TABLE}.ActiveViewMeasurability ;;
  }

  dimension: active_view_measurable_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.ActiveViewMeasurableCost ;;
  }

  dimension: active_view_measurable_impressions {
    hidden: yes
    type: number
    sql: ${TABLE}.ActiveViewMeasurableImpressions ;;
  }

  dimension: active_view_viewability {
    hidden: yes
    type: number
    sql: ${TABLE}.ActiveViewViewability ;;
  }

  dimension: ad_network_type1 {
    hidden: yes
    type: string
    sql: ${TABLE}.AdNetworkType1 ;;
  }

  dimension: ad_network_type2 {
    hidden: yes
    type: string
    sql: ${TABLE}.AdNetworkType2 ;;
  }

  dimension: clicks {
    hidden: yes
    type: number
    sql: ${TABLE}.clicks ;;
  }

  dimension: conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.conversions ;;
  }

  dimension: conversionvalue {
    hidden: yes
    type: number
    sql: ${TABLE}.conversionvalue ;;
  }

  dimension: cost {
    hidden: yes
    type: number
    sql: ${TABLE}.cost / 1000000;;
  }

  dimension: device {
    hidden: yes
    type: string
    sql: ${TABLE}.Device ;;
  }

  dimension: impressions {
    hidden: yes
    type: number
    sql: ${TABLE}.impressions ;;
  }

  dimension: interactions {
    hidden: yes
    type: number
    sql: ${TABLE}.Interactions ;;
  }

  dimension: interaction_types {
    hidden: yes
    type: string
    sql: ${TABLE}.InteractionTypes ;;
  }

  dimension: slot {
    hidden: yes
    type: string
    sql: ${TABLE}.Slot ;;
  }

  dimension: view_through_conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.ViewThroughConversions ;;
  }
}

explore: ad_impressions_hour_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_adapter]
  from: ad_impressions_hour_adapter
  view_name: fact
}

view: ad_impressions_hour_adapter {
  extends: [ad_impressions_adapter, hour_base]

  derived_table: {
    sql:
        SELECT
          CURRENT_DATE as _DATA_DATE,
          CURRENT_DATE as _LATEST_DATE,
          CAST('NA' as TEXT) as ExternalCustomerId,
          0 as AveragePosition,
          0 as ActiveViewImpressions,
          0 as ActiveViewMeasurability,
          0 as ActiveViewMeasurableCost,
          0 as ActiveViewMeasurableImpressions,
          0 as ActiveViewViewability,
          CAST('NA' as TEXT) as AdNetworkType1,
          CAST('NA' as TEXT) as AdNetworkType2,
          0 as clicks,
          0 as conversions,
          0 as conversionvalue,
          0 as cost,
          CAST('NA' as TEXT) as Device,
          0 as impressions,
          0 as Interactions,
          CAST('NA' as TEXT) as InteractionTypes,
          CAST('NA' as TEXT) as Slot,
          0 as ViewThroughConversions,
          0 as HourOfDay,
          CAST('NA' as TEXT) as CampaignId,
          CAST('NA' as TEXT) as AdGroupId,
          CAST('NA' as TEXT) as CriterionId
        ;;
  }
}

explore: ad_impressions_campaign_adapter {
  extends: [ad_impressions_adapter, campaign_join]
  from: ad_impressions_campaign_adapter
  view_name: fact
}

view: ad_impressions_campaign_adapter {
  extends: [ad_impressions_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE as _DATA_DATE,
        CURRENT_DATE as _LATEST_DATE,
        CAST('NA' as TEXT) as ExternalCustomerId,
        0 as AveragePosition,
        0 as ActiveViewImpressions,
        0 as ActiveViewMeasurability,
        0 as ActiveViewMeasurableCost,
        0 as ActiveViewMeasurableImpressions,
        0 as ActiveViewViewability,
        CAST('NA' as TEXT) as AdNetworkType1,
        CAST('NA' as TEXT) as AdNetworkType2,
        0 as clicks,
        0 as conversions,
        0 as conversionvalue,
        0 as cost,
        CAST('NA' as TEXT) as Device,
        0 as impressions,
        0 as Interactions,
        CAST('NA' as TEXT) as InteractionTypes,
        CAST('NA' as TEXT) as Slot,
        0 as ViewThroughConversions,
        CAST('NA' as TEXT) as BaseCampaignId,
        CAST('NA' as TEXT) as CampaignId,
        CAST('NA' as TEXT) as AdGroupId,
        CAST('NA' as TEXT) as CriterionId
      ;;
  }

  dimension: base_campaign_id {
    hidden: yes
    sql: ${TABLE}.BaseCampaignId ;;
  }

  dimension: campaign_id {
    hidden: yes
    sql: ${TABLE}.CampaignId ;;
  }

  dimension: campaign_id_string {
    hidden: yes
    sql: CAST(${campaign_id} as TEXT) ;;
  }
}

explore: ad_impressions_campaign_hour_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_campaign_adapter]
  from: ad_impressions_campaign_hour_adapter
  view_name: fact
}

view: ad_impressions_campaign_hour_adapter {
  extends: [ad_impressions_campaign_adapter, hour_base]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE as _DATA_DATE,
        CURRENT_DATE as _LATEST_DATE,
        CAST('NA' as TEXT) as ExternalCustomerId,
        0 as AveragePosition,
        0 as ActiveViewImpressions,
        0 as ActiveViewMeasurability,
        0 as ActiveViewMeasurableCost,
        0 as ActiveViewMeasurableImpressions,
        0 as ActiveViewViewability,
        CAST('NA' as TEXT) as AdNetworkType1,
        CAST('NA' as TEXT) as AdNetworkType2,
        0 as clicks,
        0 as conversions,
        0 as conversionvalue,
        0 as cost,
        CAST('NA' as TEXT) as Device,
        0 as impressions,
        0 as Interactions,
        CAST('NA' as TEXT) as InteractionTypes,
        CAST('NA' as TEXT) as Slot,
        0 as ViewThroughConversions,
        CAST('NA' as TEXT) as BaseCampaignId,
        CAST('NA' as TEXT) as CampaignId,
        0 as HourOfDay,
        CAST('NA' as TEXT) as AdGroupId,
        CAST('NA' as TEXT) as CriterionId
      ;;
  }
}

explore: ad_impressions_ad_group_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_campaign_adapter, ad_group_join]
  from: ad_impressions_ad_group_adapter
  view_name: fact
}

view: ad_impressions_ad_group_adapter {
  extends: [ad_impressions_campaign_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE as _DATA_DATE,
        CURRENT_DATE as _LATEST_DATE,
        CAST('NA' as TEXT) as ExternalCustomerId,
        0 as AveragePosition,
        0 as ActiveViewImpressions,
        0 as ActiveViewMeasurability,
        0 as ActiveViewMeasurableCost,
        0 as ActiveViewMeasurableImpressions,
        0 as ActiveViewViewability,
        CAST('NA' as TEXT) as AdNetworkType1,
        CAST('NA' as TEXT) as AdNetworkType2,
        0 as clicks,
        0 as conversions,
        0 as conversionvalue,
        0 as cost,
        CAST('NA' as TEXT) as Device,
        0 as impressions,
        0 as Interactions,
        CAST('NA' as TEXT) as InteractionTypes,
        CAST('NA' as TEXT) as Slot,
        0 as ViewThroughConversions,
        CAST('NA' as TEXT) as AdGroupId,
        CAST('NA' as TEXT) as BaseAdGroupId,
        CAST('NA' as TEXT) as CampaignId,
        CAST('NA' as TEXT) as CriterionId
      ;;
  }

  dimension: ad_group_id {
    hidden: yes
    sql: ${TABLE}.AdGroupId ;;
  }

  dimension: ad_group_id_string {
    hidden: yes
    sql: CAST(${ad_group_id} as TEXT) ;;
  }

  dimension: base_ad_group_id {
    hidden: yes
    sql: ${TABLE}.BaseAdGroupId ;;
  }
}

explore: ad_impressions_ad_group_hour_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_ad_group_adapter]
  from: ad_impressions_ad_group_hour_adapter
  view_name: fact
}

view: ad_impressions_ad_group_hour_adapter {
  extends: [ad_impressions_ad_group_adapter, hour_base]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE as _DATA_DATE,
        CURRENT_DATE as _LATEST_DATE,
        CAST('NA' as TEXT) as ExternalCustomerId,
        0 as AveragePosition,
        0 as ActiveViewImpressions,
        0 as ActiveViewMeasurability,
        0 as ActiveViewMeasurableCost,
        0 as ActiveViewMeasurableImpressions,
        0 as ActiveViewViewability,
        CAST('NA' as TEXT) as AdNetworkType1,
        CAST('NA' as TEXT) as AdNetworkType2,
        0 as clicks,
        0 as conversions,
        0 as conversionvalue,
        0 as cost,
        CAST('NA' as TEXT) as Device,
        0 as impressions,
        0 as Interactions,
        CAST('NA' as TEXT) as InteractionTypes,
        CAST('NA' as TEXT) as Slot,
        0 as ViewThroughConversions,
        CAST('NA' as TEXT) as AdGroupId,
        CAST('NA' as TEXT) as BaseAdGroupId,
        0 as HourOfDay,
        CAST('NA' as TEXT) as CampaignId,
        CAST('NA' as TEXT) as CriterionId
      ;;
  }
}

explore: ad_impressions_keyword_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_ad_group_adapter, keyword_join]
  from: ad_impressions_keyword_adapter
  view_name: fact
}

view: ad_impressions_keyword_adapter {
  extends: [ad_impressions_ad_group_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE as _DATA_DATE,
        CURRENT_DATE as _LATEST_DATE,
        CAST('NA' as TEXT) as ExternalCustomerId,
        0 as AveragePosition,
        0 as ActiveViewImpressions,
        0 as ActiveViewMeasurability,
        0 as ActiveViewMeasurableCost,
        0 as ActiveViewMeasurableImpressions,
        0 as ActiveViewViewability,
        CAST('NA' as TEXT) as AdNetworkType1,
        CAST('NA' as TEXT) as AdNetworkType2,
        0 as clicks,
        0 as conversions,
        0 as conversionvalue,
        0 as cost,
        CAST('NA' as TEXT) as Device,
        0 as impressions,
        0 as Interactions,
        CAST('NA' as TEXT) as InteractionTypes,
        CAST('NA' as TEXT) as Slot,
        0 as ViewThroughConversions,
        CAST('NA' as TEXT) as CampaignId,
        CAST('NA' as TEXT) as AdGroupId,
        CAST('NA' as TEXT) as BaseAdGroupId,
        CAST('NA' as TEXT) as CriterionId
      ;;
  }

  dimension: criterion_id {
    hidden: yes
    sql: ${TABLE}.CriterionId ;;
  }

  dimension: criterion_id_string {
    hidden: yes
    sql: CAST(${criterion_id} as TEXT) ;;
  }
}

explore: ad_impressions_ad_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_keyword_adapter, ad_join]
  from: ad_impressions_ad_adapter
  view_name: fact
}

view: ad_impressions_ad_adapter {
  extends: [ad_impressions_keyword_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE as _DATA_DATE,
        CURRENT_DATE as _LATEST_DATE,
        CAST('NA' as TEXT) as ExternalCustomerId,
        0 as AveragePosition,
        0 as ActiveViewImpressions,
        0 as ActiveViewMeasurability,
        0 as ActiveViewMeasurableCost,
        0 as ActiveViewMeasurableImpressions,
        0 as ActiveViewViewability,
        CAST('NA' as TEXT) as AdNetworkType1,
        CAST('NA' as TEXT) as AdNetworkType2,
        0 as clicks,
        0 as conversions,
        0 as conversionvalue,
        0 as cost,
        CAST('NA' as TEXT) as Device,
        0 as impressions,
        0 as Interactions,
        CAST('NA' as TEXT) as InteractionTypes,
        CAST('NA' as TEXT) as Slot,
        0 as ViewThroughConversions,
        CAST('NA' as TEXT) as CreativeId,
        CAST('NA' as TEXT) as CampaignId,
        CAST('NA' as TEXT) as AdGroupId,
        CAST('NA' as TEXT) as CriterionId
      ;;
  }

  dimension: creative_id {
    hidden: yes
    sql: ${TABLE}.CreativeId ;;
  }

  dimension: creative_id_string {
    hidden: yes
    sql: CAST(${creative_id} as TEXT) ;;
  }
}

explore: ad_impressions_age_range_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_keyword_adapter]
  from: ad_impressions_age_range_adapter
  view_name: fact

  join: criteria {
    from: age_range_adapter
    view_label: "Age Range"
    sql_on: ${fact.criterion_id} = ${criteria.criterion_id} AND
      ${fact.ad_group_id} = ${criteria.ad_group_id} AND
      ${fact.campaign_id} = ${criteria.campaign_id} AND
      ${fact.external_customer_id} = ${criteria.external_customer_id} AND
      ${criteria.latest} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_age_range_adapter {
  extends: [ad_impressions_keyword_adapter]
}

explore: ad_impressions_audience_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_keyword_adapter]
  from: ad_impressions_audience_adapter
  view_name: fact

  join: criteria {
    from: audience_adapter
    view_label: "Audience"
    sql_on: ${fact.criterion_id} = ${criteria.criterion_id} AND
      ${fact.ad_group_id} = ${criteria.ad_group_id} AND
      ${fact.campaign_id} = ${criteria.campaign_id} AND
      ${fact.external_customer_id} = ${criteria.external_customer_id} AND
      ${criteria.latest} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_audience_adapter {
  extends: [ad_impressions_keyword_adapter]
}

explore: ad_impressions_gender_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_keyword_adapter]
  from: ad_impressions_gender_adapter
  view_name: fact

  join: criteria {
    from: gender_adapter
    view_label: "Gender"
    sql_on: ${fact.criterion_id} = ${criteria.criterion_id} AND
      ${fact.ad_group_id} = ${criteria.ad_group_id} AND
      ${fact.campaign_id} = ${criteria.campaign_id} AND
      ${fact.external_customer_id} = ${criteria.external_customer_id} AND
      ${criteria.latest} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_gender_adapter {
  extends: [ad_impressions_keyword_adapter]
}

explore: ad_impressions_parental_status_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_keyword_adapter]
  from: ad_impressions_parental_status_adapter
  view_name: fact

  join: criteria {
    from: parental_status_adapter
    view_label: "Parental Status"
    sql_on: ${fact.criterion_id} = ${criteria.criterion_id} AND
      ${fact.ad_group_id} = ${criteria.ad_group_id} AND
      ${fact.campaign_id} = ${criteria.campaign_id} AND
      ${fact.external_customer_id} = ${criteria.external_customer_id} AND
      ${criteria.latest} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_parental_status_adapter {
  extends: [ad_impressions_keyword_adapter]
}

explore: ad_impressions_video_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_ad_group_adapter]
  from: ad_impressions_video_adapter
  view_name: fact

  join: video {
    from: video_adapter
    view_label: "Video"
    sql_on: ${fact.video_id} = ${video.video_id} AND
      ${fact.ad_group_id} = ${video.ad_group_id} AND
      ${fact.campaign_id} = ${video.campaign_id} AND
      ${fact.external_customer_id} = ${video.external_customer_id} AND
      ${video.latest} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_video_adapter {
  extends: [google_adwords_base, transformations_base]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE as _DATA_DATE,
        CURRENT_DATE as _LATEST_DATE,
        CAST('NA' as TEXT) as ExternalCustomerId,
        0 as AveragePosition,
        0 as ActiveViewImpressions,
        0 as ActiveViewMeasurability,
        0 as ActiveViewMeasurableCost,
        0 as ActiveViewMeasurableImpressions,
        0 as ActiveViewViewability,
        CAST('NA' as TEXT) as AdNetworkType1,
        CAST('NA' as TEXT) as AdNetworkType2,
        0 as clicks,
        0 as conversions,
        0 as conversionvalue,
        0 as cost,
        CAST('NA' as TEXT) as Device,
        0 as impressions,
        0 as Interactions,
        CAST('NA' as TEXT) as InteractionTypes,
        CAST('NA' as TEXT) as Slot,
        0 as ViewThroughConversions,
        CAST('NA' as TEXT) as AdGroupId,
        CAST('NA' as TEXT) as CampaignId,
        CAST('NA' as TEXT) as CreativeId,
        CAST('NA' as TEXT) as CreativeStatus,
        CAST('NA' as TEXT) as Device,
        CAST('NA' as TEXT) as VideoId,
        CAST('NA' as TEXT) as VideoChannelId
      ;;
  }

  dimension: ad_group_id {
    hidden: yes
    sql: ${TABLE}.AdGroupId ;;
  }

  dimension: ad_group_id_string {
    hidden: yes
    sql: CAST(${ad_group_id} as TEXT) ;;
  }

  dimension: ad_network_type1 {
    hidden: yes
    type: string
    sql: ${TABLE}.AdNetworkType1 ;;
  }

  dimension: ad_network_type2 {
    hidden: yes
    type: string
    sql: ${TABLE}.AdNetworkType2 ;;
  }

  dimension: campaign_id {
    hidden: yes
    sql: ${TABLE}.CampaignId ;;
  }

  dimension: campaign_id_string {
    hidden: yes
    sql: CAST(${campaign_id} as TEXT) ;;
  }

  dimension: clicks {
    hidden: yes
    type: number
    sql: ${TABLE}.clicks ;;
  }

  dimension: conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.conversions ;;
  }

  dimension: conversionvalue {
    hidden: yes
    type: number
    sql: ${TABLE}.conversionvalue ;;
  }

  dimension: cost {
    hidden: yes
    type: number
    sql: ${TABLE}.cost / 1000000;;
  }

  dimension: creative_id {
    hidden: yes
    sql: ${TABLE}.CreativeId ;;
  }

  dimension: creative_id_string {
    hidden: yes
    sql: CAST(${creative_id} as TEXT) ;;
  }

  dimension: creative_status {
    hidden: yes
    sql: ${TABLE}.CreativeStatus ;;
  }

  dimension: device {
    hidden: yes
    type: string
    sql: ${TABLE}.Device ;;
  }

  dimension: impressions {
    hidden: yes
    type: number
    sql: ${TABLE}.impressions ;;
  }

  dimension: video_id {
    hidden: yes
    sql: ${TABLE}.VideoId ;;
  }

  dimension: video_channel_id {
    hidden: yes
    sql: ${TABLE}.VideoChannelId ;;
  }

  dimension: view_through_conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.ViewThroughConversions ;;
  }
}

explore: ad_impressions_geo_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_ad_group_adapter]
  from: ad_impressions_geo_adapter
  view_name: fact

  join: geo_country {
    from: geotargeting
    view_label: "Country"
    fields: [country_code]
    sql_on: ${fact.country_criteria_id} = ${geo_country.criteria_id} ;;
    relationship: many_to_one
  }

  join: geo_us_state {
    from: geotargeting
    view_label: "US State"
    fields: [state]
    sql_on: ${fact.region_criteria_id} = ${geo_us_state.criteria_id} AND
      ${geo_us_state.is_us_state} ;;
    relationship: many_to_one
    type: inner
  }

  join: geo_us_postal_code {
    from: geotargeting
    view_label: "US Postal Code"
    fields: [postal_code]
    sql_on: ${fact.most_specific_criteria_id} = ${geo_us_postal_code.criteria_id} AND
      ${geo_us_postal_code.is_us_postal_code} ;;
    relationship: many_to_one
    type: inner
  }

  join: geo_us_postal_code_state {
    from: geotargeting
    view_label: "US Postal Code"
    fields: [state]
    sql_on: ${geo_us_postal_code.parent_id} = ${geo_us_postal_code_state.criteria_id} AND
      ${geo_us_postal_code_state.is_us_state} ;;
    relationship: many_to_one
    type: inner
    required_joins: [geo_us_postal_code]
  }

  join: geo_region {
    from: geotargeting
    view_label: "Region"
    fields: [name, country_code]
    sql_on: ${fact.region_criteria_id} = ${geo_region.criteria_id} ;;
    relationship: many_to_one
  }

  join: geo_metro {
    from: geotargeting
    view_label: "Metro"
    fields: [name, country_code]
    sql_on: ${fact.metro_criteria_id} = ${geo_metro.criteria_id} ;;
    relationship: many_to_one
  }

  join: geo_city {
    from: geotargeting
    view_label: "City"
    fields: [name, country_code]
    sql_on: ${fact.city_criteria_id} = ${geo_city.criteria_id} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_geo_adapter {
  extends: [ad_impressions_ad_group_adapter]

  derived_table: {
    sql:
      SELECT
        CURRENT_DATE as _DATA_DATE,
        CURRENT_DATE as _LATEST_DATE,
        CAST('NA' as TEXT) as ExternalCustomerId,
        0 as AveragePosition,
        0 as ActiveViewImpressions,
        0 as ActiveViewMeasurability,
        0 as ActiveViewMeasurableCost,
        0 as ActiveViewMeasurableImpressions,
        0 as ActiveViewViewability,
        CAST('NA' as TEXT) as AdNetworkType1,
        CAST('NA' as TEXT) as AdNetworkType2,
        0 as clicks,
        0 as conversions,
        0 as conversionvalue,
        0 as cost,
        CAST('NA' as TEXT) as Device,
        0 as impressions,
        0 as Interactions,
        CAST('NA' as TEXT) as InteractionTypes,
        CAST('NA' as TEXT) as Slot,
        0 as ViewThroughConversions,
        CAST('NA' as TEXT) as CityCriteriaId,
        CAST('NA' as TEXT) as CountryCriteriaId,
        CAST('NA' as TEXT) as MetroCriteriaId,
        CAST('NA' as TEXT) as MostSpecificCriteriaId,
        CAST('NA' as TEXT) as RegionCriteriaId,
        CAST('NA' as TEXT) as CampaignId,
        CAST('NA' as TEXT) as AdGroupId,
        CAST('NA' as TEXT) as CriterionId
      ;;
  }

  dimension: city_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.CityCriteriaId ;;
  }

  dimension: country_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.CountryCriteriaId ;;
  }

  dimension: metro_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.MetroCriteriaId ;;
  }

  dimension: most_specific_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.MostSpecificCriteriaId ;;
  }

  dimension: region_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.RegionCriteriaId ;;
  }
}
