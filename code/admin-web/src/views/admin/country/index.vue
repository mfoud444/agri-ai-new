 <script setup lang='ts'>
import { h, reactive } from 'vue';
import {
  DataTableColumns,
  NText,
  NSwitch
} from 'naive-ui';
import { DataTableBase, SvgIcon } from '@/components/common';
import { useCountryStore } from '@/store';
import { t } from '@/locales';
import FormView from './FormView.vue';

// Use the country store
const objStore = useCountryStore();

// Define the table columns for Country
const columns = reactive<DataTableColumns<API.Country>>([
  {
    title: t('common.name'),
    key: 'name',
    align: 'center',
    render(row: API.Country) {
      return h(
    'div',
    {
      style: {
        display: 'flex',
        alignItems: 'center',
      },
    },
    [
      h(SvgIcon, {
        icon: 'flagpack:' + (row.alpha_2.toLowerCase()),
        class: 'w-12 h-12',
      }),
      h(
        'span',
        {
          style: {
            marginLeft: '8px',
          },
        },
        row.name,
      ),
    ],
  );
    },
    sorter: 'default',
  },
  {
    title: t('common.alpha2'),
    key: 'alpha2',
    align: 'center',
    render(row: API.Country) {
      return h(NText, {}, { default: () => row.alpha_2 });
    },
  },
  {
    title: t('common.alpha3'),
    key: 'alpha3',
    align: 'center',
    render(row: API.Country) {
      return h(NText, {}, { default: () => row.alpha_3 });
    },
  },
  {
    title: t('common.countryCode'),
    key: 'countryCode',
    align: 'center',
    render(row: API.Country) {
      return h(NText, {}, { default: () => row.countryCode });
    },
  },
  {
    title: t('common.region'),
    key: 'region',
    align: 'center',
    render(row: API.Country) {
      return h(NText, {}, { default: () => row.region });
    },
  },
  {
    title: t('common.subRegion'),
    key: 'subRegion',
    align: 'center',
    render(row: API.Country) {
      return h(NText, {}, { default: () => row.subRegion });
    },
  },
  {
    title: t('common.intermediateRegion'),
    key: 'intermediateRegion',
    align: 'center',
    render(row: API.Country) {
      return row.intermediateRegion ? h(NText, {}, { default: () => row.intermediateRegion }) : null;
    },
    ellipsis: true,
  },
  {
    title: t('common.isActivate'),
    key: 'isActivate',
    align: 'center',
    render(row: API.Country) {
      return h(NSwitch, { value: row.isActivate, disabled: true });
    },
  },
  {
    title: t('common.createdAt'),
    key: 'createdAt',
    align: 'center',
    render(row: API.Country) {
      return h(NText, {}, { default: () => new Date(row.createdAt).toLocaleString() });
    },
    sorter: (a, b) => Number(new Date(a.createdAt)) - Number(new Date(b.createdAt)),
  },
  {
    title: t('common.updatedAt'),
    key: 'updatedAt',
    align: 'center',
    render(row: API.Country) {
      return h(NText, {}, { default: () => new Date(row.updatedAt).toLocaleString() });
    },
  }
]);

</script>

<template>
  <DataTableBase
    :title="t('common.country')"
    :objStore="objStore"
    :columns="columns"
    :FormView="FormView"
  />
</template> 
