using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowGrid : Task
{
    public GameObject grid;

    public override void StartTask()
    {
        base.StartTask();
        grid.SetActive(true);
        base.EndTask();
        Destroy(this.gameObject);
    }

/*    private IEnumerator closeGrid()
    {
        yield return new WaitForSeconds(12f);
        grid.SetActive(false);
    }

    public override void EndTask()
    {
        base.EndTask();
        StartCoroutine(closeGrid());
    }*/
}
