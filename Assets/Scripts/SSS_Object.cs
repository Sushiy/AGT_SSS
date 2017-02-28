using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//An Object that should receive all the different SSSMaterials
public class SSS_Object : MonoBehaviour
{
    public bool m_bEnabled = false;

    //All Meshrenderers of this Object
    [SerializeField]
    Transform m_transMeshParent;
    [SerializeField]
    Transform m_transDepthMeshParent;
    MeshRenderer[] m_arrmeshrendererRenderMeshes;
    MeshRenderer[] m_arrmeshrendererDepthMeshes;    //All DepthMesh Renderers

    int m_iMaterialIndex = 0;

    private void Awake()
    {
        //Grab all MeshRenderers
        m_arrmeshrendererRenderMeshes = m_transMeshParent.GetComponentsInChildren<MeshRenderer>();
        m_arrmeshrendererDepthMeshes = m_transDepthMeshParent.GetComponentsInChildren<MeshRenderer>();
    }

    // Use this for initialization
    void Start ()
    {
        ToggleMeshes();
	}

    //Go through different States of this Object: Disabled, Material_0, Material_1,...Material_n 
    public void Toggle(Material[] _arrmatSSS)
    {
        if(!m_bEnabled)
        {
            m_bEnabled = true;
            ToggleMeshes();
            m_iMaterialIndex = 0;
            SetMeshMaterial(_arrmatSSS[m_iMaterialIndex]);
        }

        else
        {
            int iLen = _arrmatSSS.Length;
            if(m_iMaterialIndex + 1 < iLen)
            {
                m_iMaterialIndex++;
                SetMeshMaterial(_arrmatSSS[m_iMaterialIndex]);
            }
            else
            {
                m_iMaterialIndex = 0;
                m_bEnabled = false;
                ToggleMeshes();
            }
        }

    }

    //Enable/disable all MeshRenderers (and DepthMesh Renderers)
    void ToggleMeshes()
    {
        foreach (MeshRenderer mesh in m_arrmeshrendererRenderMeshes)
        {
            mesh.enabled = m_bEnabled;
        }
        foreach (MeshRenderer mesh in m_arrmeshrendererDepthMeshes)
        {
            mesh.enabled = m_bEnabled;
        }
    }

    //Set the Material for all MeshRenderers (Not DepthMeshRenderers)
    void SetMeshMaterial(Material _mat)
    {
        foreach (MeshRenderer mesh in m_arrmeshrendererRenderMeshes)
        {
            mesh.material = _mat;
        }
    }
}
