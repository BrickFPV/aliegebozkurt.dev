grant usage on schema public to authenticated, service_role;
grant select on public.profiles to authenticated, service_role;
grant select, insert, update, delete on public.notes to authenticated, service_role;
grant execute on function public.is_admin() to authenticated;

drop policy if exists "Users read own or admins read all profiles" on public.profiles;
create policy "Users read own or admins read all profiles"
on public.profiles for select to authenticated
using (id = (select auth.uid()) or public.is_admin());

drop policy if exists "Users read own or admins read all notes" on public.notes;
create policy "Users read own or admins read all notes"
on public.notes for select to authenticated
using (member_id = (select auth.uid()) or public.is_admin());

drop policy if exists "Admins insert notes" on public.notes;
create policy "Admins insert notes"
on public.notes for insert to authenticated
with check (public.is_admin());

drop policy if exists "Admins update notes" on public.notes;
create policy "Admins update notes"
on public.notes for update to authenticated
using (public.is_admin()) with check (public.is_admin());

drop policy if exists "Admins delete notes" on public.notes;
create policy "Admins delete notes"
on public.notes for delete to authenticated
using (public.is_admin());
